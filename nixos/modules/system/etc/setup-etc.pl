use strict;
use File::Find;
use File::Copy;
use File::Path;
use File::Basename;
use File::Slurp;

my $etc = $ARGV[0] or die;
my $static = "/etc/static";

sub atomicSymlink {
    my ($source, $target) = @_;
    my $tmp = "$target.tmp";
    unlink $tmp;
    symlink $source, $tmp or return 0;
    rename $tmp, $target or return 0;
    return 1;
}


# Atomically update /etc/static to point at the etc files of the
# current configuration.
atomicSymlink $etc, $static or die;

# Returns 1 if the argument points to the files in /etc/static.  That
# means either argument is a symlink to a file in /etc/static or a
# directory with all children being static.
sub isStatic {
    my $path = shift;

    if (-l $path) {
        my $target = readlink $path;
        return substr($target, 0, length "/etc/static/") eq "/etc/static/";
    }

    if (-d $path) {
        opendir DIR, "$path" or return 0;
        my @names = readdir DIR or die;
        closedir DIR;

        foreach my $name (@names) {
            next if $name eq "." || $name eq "..";
            unless (isStatic("$path/$name")) {
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
    if ($File::Find::name eq "/etc/nixos") {
        $File::Find::prune = 1;
        return;
    }
    if (-l $_) {
        my $target = readlink $_;
        if (substr($target, 0, length $static) eq $static) {
            my $x = "/etc/static/" . substr($File::Find::name, length "/etc/");
            unless (-l $x) {
                print STDERR "removing obsolete symlink ‘$File::Find::name’...\n";
                unlink "$_";
            }
        }
    }
}

find(\&cleanup, "/etc");


# Use /etc/.clean to keep track of copied files.
my @oldClean = read_file("/etc/.clean", chomp => 1, err_mode => 'quiet');
open CLEAN, ">>/etc/.clean";


# Leave all copied files owned by root and with their Nix store permissions
# until all files are in place, in case /etc/passwd or /etc/group are being
# updated this way. Since we're deferring ownership changes, we have to also
# defer permissions changes; otherwise an unprivileged service could lose
# access to its config files during this window. Leaving files readable by
# everyone for a bit isn't a security problem because the source of these files
# is already world-readable in the Nix store.
my %copied;
sub set_ownership {
    my $target = shift;
    $copied{$target} = \@_;
}

# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
my %created;
my @clean;

sub link {
    my $fn = substr $File::Find::name, length($etc) + 1 or next;
    my $target = "/etc/$fn";
    File::Path::make_path(dirname $target);
    $created{$fn} = 1;

    # Rename doesn't work if target is directory.
    if (-l $_ && -d $target) {
        if (isStatic $target) {
            rmtree $target or warn;
        } else {
            warn "$target directory contains user files. Symlinking may fail.";
        }
    }

    if (-e "$_.mode") {
        my $mode = read_file("$_.mode"); chomp $mode;
        if ($mode eq "direct-symlink") {
            atomicSymlink readlink("$static/$fn"), $target or warn;
        } else {
            my $uid = read_file("$_.uid"); chomp $uid;
            my $gid = read_file("$_.gid"); chomp $gid;
            copy "$static/$fn", "$target.tmp" or warn;
            rename "$target.tmp", $target or warn;
            set_ownership $target, oct($mode), $uid, $gid;
        }
        push @clean, $fn;
        print CLEAN "$fn\n";
    } elsif (-l "$_") {
        atomicSymlink "$static/$fn", $target or warn;
    }
}

find(\&link, $etc);


# Now that all files are in place, it should be safe to call getpwnam and
# getgrnam.
foreach my $target (keys %copied) {
    my ($mode, $uid, $gid) = @{$copied{$target}};
    $uid = getpwnam $uid unless $uid =~ /^\+/;
    $gid = getgrnam $gid unless $gid =~ /^\+/;
    chown int($uid), int($gid), "$target" or warn;
    chmod $mode, "$target" or warn;
}


# Delete files that were copied in a previous version but not in the
# current.
foreach my $fn (@oldClean) {
    if (!defined $created{$fn}) {
        $fn = "/etc/$fn";
        print STDERR "removing obsolete file ‘$fn’...\n";
        unlink "$fn";
    }
}


# Rewrite /etc/.clean.
close CLEAN;
write_file("/etc/.clean", map { "$_\n" } @clean);
