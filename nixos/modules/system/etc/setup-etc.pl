#! @perl@/bin/perl

use v5.34;
use warnings;
use experimental qw(try signatures);

use File::Basename qw(dirname);
use File::Copy qw(copy);
use File::Find qw(find);
use File::Path qw(make_path rmtree);
use File::Slurp qw(read_file write_file read_dir);

my $etc = $ARGV[0];
if ($etc eq "") {
    die("This script must be called with an argument which expresses the new /etc directory in the nix store");
}
use constant STATIC => "/etc/static";

my @cleanup_errors;
my @symlink_errors;


# Create a symlink atomically from argument 2 -> argument 1
sub atomic_symlink ($source, $target) {
    my $tmp = "$target.tmp";
    unlink($tmp);
    if (-e $tmp) {
        die("Failed to remove `$tmp` file before linking");
    }
    symlink($source, $tmp) or die("Failed to create symlink `$tmp` -> `$source`: $!");
    rename($tmp, $target) or die("Failed to move `$tmp` -> `$target`: $!");
}


# Atomically update /etc/static to point at the etc files of the
# current configuration.
try {
    atomic_symlink($etc, STATIC);
}
catch ($e) {
    die("Failed to create symlink for /etc: $e");
}


# Returns 1 if the argument points to the files in /etc/static.  That
# means either argument is a symlink to a file in /etc/static or a
# directory with all children being static.
sub is_static ($path) {
    if (-l $path) {
        my $target = readlink($path);
        return substr($target, 0, length(STATIC)) eq STATIC;
    }

    if (-d $path) {
        my @names = read_dir($path);
        foreach my $name (@names) {
            if (not (is_static("$path/$name"))) {
                return;
            }
        }
        return 1;
    }
    return;
}

# Remove dangling symlinks that point to /etc/static.  These are
# configuration files that existed in a previous configuration but not
# in the current one.  For efficiency, don't look under /etc/nixos
# (where all the NixOS sources live) and /etc/static which is what we're
# comparing to anyway.
sub cleanup {
    my $filename = $_;

    try {
        if ($File::Find::name eq "/etc/nixos" || $File::Find::name eq STATIC) {
            $File::Find::prune = 1;
            return;
        }
        if (-l $filename) {
            my $target = readlink($filename);
            if (substr($target, 0, length(STATIC)) eq STATIC) {
                my $x = STATIC . substr($File::Find::name, length("/etc/"));
                # Check if symlink is still present in new etc
                if (not (-l $x)) {
                    warn("removing obsolete symlink ‘$File::Find::name’...\n");
                    unlink($filename) or die("Failed to remove `$filename`: $!");
                }
            }
        }
        return;
    }
    catch ($e) {
        push(@cleanup_errors, $e);
    }
}

find(\&cleanup, "/etc");
if (@cleanup_errors) {
    warn("Something went wrong while removing dangling symlinks:");
    warn(map({ "- $_\n" } @cleanup_errors));
    warn("Please remove these symlinks manually to prevent security implications.");
}


# Use /etc/.clean to keep track of copied files.
my @old_copied = read_file("/etc/.clean", chomp => 1, err_mode => 'quiet');


# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
my %created;
my @copied;

sub make_symlinks {
    my $path_to_file = $_;

    try {
        # This is needed to avoid a warning if we take the substr of the first
        # directory, i.e., the /nix/store/.../etc itself
        if (length($File::Find::name) == length($etc)) {
            return;
        }

        # Strip away /nix/store/<hash>-etc/etc/ from filename
        my $fn = substr($File::Find::name, length($etc) + 1) or return;

        # nixos-enter sets up /etc/resolv.conf as a bind mount, so skip it.
        if ($fn eq "resolv.conf" and $ENV{'IN_NIXOS_ENTER'}) {
            return;
        }

        my $target = "/etc/$fn";
        make_path(dirname($target));
        $created{$fn} = 1;

        # Rename doesn't work if target is directory.
        if (-l $path_to_file && -d $target) {
            if (is_static($target)) {
                rmtree($target) or die("Failed to remove directory `$target`: $!");
            } else {
                warn("$target directory contains user files. Symlinking may fail.");
            }
        }

        # This will set uid/gid if the options were set in the nix config
        if (-e "$path_to_file.mode") {
            chomp(my $mode = read_file("$path_to_file.mode"));
            if ($mode eq "direct-symlink") {
                atomic_symlink(readlink(STATIC . "/$fn"), $target) or warn("Failed to symlink `$target`");
            } else {
                my $uid = read_file("$path_to_file.uid", { chomp => 1 });
                my $gid = read_file("$path_to_file.gid", { chomp => 1 });
                copy(STATIC . "/$fn", "$target.tmp") or warn("Copy failed: $!");

                # uid could either be an uid or an username, this gets the uid
                if ($uid !~ /^\+/) {
                    $uid = getpwnam($uid) or warn("No user with name `$uid` found!");
                }
                if ($gid !~ /^\+/) {
                    $gid = getgrnam($gid) or warn("No group with name `$uid` found!");
                }

                chown(int($uid), int($gid), "$target.tmp") or die("Chowning `$target` failed: $!");
                chmod(oct($mode), "$target.tmp") or die("Chmod of `$target` failed: $!");
                rename("$target.tmp", $target) or die("Moving of `$target` failed: $!");
            }
            push(@copied, $fn);
        } elsif (-l $path_to_file) {
            atomic_symlink(STATIC . "/$fn", $target) or warn("Atomic symlink failed for `$target`");
        }
        return;
    }
    catch ($e) {
        push(@symlink_errors, $e);
    }
}

find(\&make_symlinks, $etc);


# Delete files that were copied in a previous version but not in the
# current.
foreach my $fn (@old_copied) {
    if (!defined $created{$fn}) {
        $fn = "/etc/$fn";
        warn("removing obsolete file ‘$fn’...\n");
        unlink($fn) or warn("Couldn't remove $fn");
    }
}


# Rewrite /etc/.clean.
write_file("/etc/.clean", { atomic => 1 }, map({ "$_\n" } sort @copied));

# Create /etc/NIXOS tag if not exists.
# When /etc is not on a persistent filesystem, it will be wiped after reboot,
# so we need to check and re-create it during activation.
write_file("/etc/NIXOS", { append => 1 }) or die("Couldn't create /etc/NIXOS");


if (@symlink_errors) {
    warn("Something went wrong while setting up the new /etc directory:");
    warn(map({ "- $_\n" } @symlink_errors));
    warn("The system is left in a potentially unsafe state!");
    exit 1;
}
