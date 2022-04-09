#! @perl@/bin/perl

use strict;
use warnings;

use File::Basename qw(dirname);
use File::Copy qw(copy);
use File::Find qw(find);
use File::Path qw(make_path rmtree);
use File::Slurp qw(read_file write_file);

my $etc = $ARGV[0];
if ($etc eq "") {
    die("This script must be called with an argument which expresses the new /etc directory in the nix store");
}
my $static = "/etc/static";

# Create a symlink atomically from argument 2 -> argument 1
sub atomic_symlink {
    my ($source, $target) = @_;
    my $tmp = "$target.tmp";
    unlink($tmp);
    symlink($source, $tmp) or return 0;
    if (rename($tmp, $target)) {
        return 1;
    } else {
        unlink($tmp);
        return 0;
    }
}


# Atomically update /etc/static to point at the etc files of the
# current configuration.
atomic_symlink($etc, $static) or die("Failed to create symlink for /etc");

# Returns 1 if the argument points to the files in /etc/static.  That
# means either argument is a symlink to a file in /etc/static or a
# directory with all children being static.
sub is_static {
    my $path = shift;

    if (-l $path) {
        my $target = readlink($path);
        return substr($target, 0, length($static)) eq $static;
    }

    if (-d $path) {
        opendir(my $dh, $path) or return 0;
        my @names = readdir($dh) or die("Failed reading directory `$dh`");
        closedir($dh);

        foreach my $name (@names) {
            if ($name eq "." || $name eq "..") {
                next;
            }
            if (not (is_static("$path/$name"))) {
                return 0;
            }
        }
        return 1;
    }
    return 0;
}

# Remove dangling symlinks that point to /etc/static.  These are
# configuration files that existed in a previous configuration but not
# in the current one.  For efficiency, don't look under /etc/nixos
# (where all the NixOS sources live).
sub cleanup {
    my $filename = $_;
    if ($File::Find::name eq "/etc/nixos" || $File::Find::name eq $static) {
        $File::Find::prune = 1;
        return;
    }
    if (-l $filename) {
        my $target = readlink($filename);
        if (substr($target, 0, length($static)) eq $static) {
            my $x = $static . substr($File::Find::name, length("/etc/"));
            # Check if symlink is still present in new etc
            if (not (-l $x)) {
                warn("removing obsolete symlink ‘$File::Find::name’...\n");
                unlink($filename);
            }
        }
    }
    return;
}

find(\&cleanup, "/etc");


# Use /etc/.clean to keep track of copied files.
my @old_copied = read_file("/etc/.clean", chomp => 1, err_mode => 'quiet');


# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
my %created;
my @copied;

sub make_symlinks {
    my $path_to_file = $_;

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
    File::Path::make_path(dirname($target));
    $created{$fn} = 1;

    # Rename doesn't work if target is directory.
    if (-l $path_to_file && -d $target) {
        if (is_static($target)) {
            rmtree($target) or warn("Failed to remove $target");
        } else {
            warn("$target directory contains user files. Symlinking may fail.");
        }
    }

    # This will set uid/gid if the options were set in the nix config
    if (-e "$path_to_file.mode") {
        chomp(my $mode = read_file("$path_to_file.mode"));
        if ($mode eq "direct-symlink") {
            atomic_symlink(readlink("$static/$fn"), $target) or warn("could not create symlink $target");
        } else {
            my $uid = read_file("$path_to_file.uid", { chomp => 1 });
            my $gid = read_file("$path_to_file.gid", { chomp => 1 });
            copy("$static/$fn", "$target.tmp") or warn;

            # uid could either be an uid or an username, this gets the uid
            if ($uid !~ /^\+/) {
                $uid = getpwnam($uid);
            }
            if ($gid !~ /^\+/) {
                $gid = getgrnam($gid);
            }

            chown(int($uid), int($gid), "$target.tmp") or warn;
            chmod(oct($mode), "$target.tmp") or warn;
            unless (rename("$target.tmp", $target)) {
                warn("could not create target $target");
                unlink("$target.tmp");
            }
        }
        push(@copied, $fn);
    } elsif (-l "$path_to_file") {
        atomic_symlink("$static/$fn", $target) or warn("could not create symlink $target");
    }

    return;
}

find(\&make_symlinks, $etc);


# Delete files that were copied in a previous version but not in the
# current.
foreach my $fn (@old_copied) {
    if (!defined $created{$fn}) {
        $fn = "/etc/$fn";
        warn("removing obsolete file ‘$fn’...\n");
        unlink($fn);
    }
}


# Rewrite /etc/.clean.
write_file("/etc/.clean", { atomic => 1 }, map({ "$_\n" } sort @copied));

# Create /etc/NIXOS tag if not exists.
# When /etc is not on a persistent filesystem, it will be wiped after reboot,
# so we need to check and re-create it during activation.
open(my $TAG, ">>", "/etc/NIXOS") or die("Couldn't create /etc/NIXOS");
close($TAG) or die ("Couldn't close /etc/NIXOS");
