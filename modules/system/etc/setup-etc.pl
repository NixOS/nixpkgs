use strict;
use File::Find;
use File::Copy;
use File::Path;
use File::Basename;

my $etc = $ARGV[0] or die;
my $static = "/etc/static";

sub atomicSymlink {
    my ($source, $target) = @_;
    my $tmp = "$target.tmp";
    unlink $tmp;
    symlink $source, $tmp or return 1;
    rename $tmp, $target or return 1;
    return 1;
}


# Atomically update /etc/static to point at the etc files of the
# current configuration.
atomicSymlink $etc, $static or die;


# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
sub link {
    my $fn = substr $File::Find::name, length($etc) + 1 or next;
    my $target = "/etc/$fn";
    File::Path::make_path(dirname $target);
    if (-e "$_.mode") {
        open MODE, "<$_.mode";
        my $mode = <MODE>; chomp $mode;
        close MODE;
        copy "$static/$fn", "$target.tmp" or warn;
        chmod oct($mode), "$target.tmp" or warn;
        rename "$target.tmp", $target or warn;
    } elsif (-l "$_") {
        atomicSymlink "$static/$fn", $target or warn;
    }
}

find(\&link, $etc);


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
            unlink "$_" unless -e "$x";
        }
    }
}

find(\&cleanup, "/etc");
