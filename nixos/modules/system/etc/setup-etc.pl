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
    if (rename $tmp, $target) {
        return 1;
    } else {
        unlink $tmp;
        return 0;
    }
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

# Use /etc/.clean to keep track of copied files and symlinks.
my @oldCopied = read_file("/etc/.clean", chomp => 1, err_mode => 'quiet');
open CLEAN, ">>/etc/.clean";


# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
my %created;
my @copied;

sub link {
    my $fn = substr $File::Find::name, length($etc) + 1 or next;

    # nixos-enter sets up /etc/resolv.conf as a bind mount, so skip it.
    if ($fn eq "resolv.conf" and $ENV{'IN_NIXOS_ENTER'}) {
        return;
    }

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
            atomicSymlink readlink("$static/$fn"), $target or warn "could not create symlink $target";
        } else {
            my $uid = read_file("$_.uid"); chomp $uid;
            my $gid = read_file("$_.gid"); chomp $gid;
            copy "$static/$fn", "$target.tmp" or warn;
            $uid = getpwnam $uid unless $uid =~ /^\+/;
            $gid = getgrnam $gid unless $gid =~ /^\+/;
            chown int($uid), int($gid), "$target.tmp" or warn;
            chmod oct($mode), "$target.tmp" or warn;
            unless (rename "$target.tmp", $target) {
                warn "could not create target $target";
                unlink "$target.tmp";
            }
        }
        push @copied, $fn;
        print CLEAN "$fn\n";
    } elsif (-l "$_") {
        atomicSymlink "$static/$fn", $target or warn "could not create symlink $target";
        push @copied, $fn;
        print CLEAN "$fn\n";
    }
}

find(\&link, $etc);


# Delete files and symlinks that were copied in a previous version but not in the
# current.
foreach my $fn (@oldCopied) {
    if (!defined $created{$fn}) {
        $fn = "/etc/$fn";
        print STDERR "removing obsolete file ‘$fn’...\n";
        unlink "$fn";
    }
}


# Rewrite /etc/.clean.
close CLEAN;
write_file("/etc/.clean", map { "$_\n" } sort @copied);

# Create /etc/NIXOS tag if not exists.
# When /etc is not on a persistent filesystem, it will be wiped after reboot,
# so we need to check and re-create it during activation.
open TAG, ">>/etc/NIXOS";
close TAG;
