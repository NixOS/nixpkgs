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
    symlink $source, $tmp or return 1;
    rename $tmp, $target or return 1;
    return 1;
}


# Atomically update /etc/static to point at the etc files of the
# current configuration.
atomicSymlink $etc, $static or die;


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
my @oldCopied = read_file("/etc/.clean", chomp => 1, err_mode => 'quiet');
open CLEAN, ">>/etc/.clean";


# For every file in the etc tree, create a corresponding symlink in
# /etc to /etc/static.  The indirection through /etc/static is to make
# switching to a new configuration somewhat more atomic.
my %created;
my @copied;

sub link {
    my $fn = substr $File::Find::name, length($etc) + 1 or next;
    my $target = "/etc/$fn";
    File::Path::make_path(dirname $target);
    $created{$fn} = 1;
    if (-e "$_.mode") {
        my $mode = read_file("$_.mode"); chomp $mode;
        if ($mode eq "direct-symlink") {
            atomicSymlink readlink("$static/$fn"), $target or warn;
        } else {
            my $uid = read_file("$_.uid"); chomp $uid;
            my $gid = read_file("$_.gid"); chomp $gid;
            copy "$static/$fn", "$target.tmp" or warn;
            chown int($uid), int($gid), "$target.tmp" or warn;
            chmod oct($mode), "$target.tmp" or warn;
            rename "$target.tmp", $target or warn;
        }
        push @copied, $fn;
        print CLEAN "$fn\n";
    } elsif (-l "$_") {
        atomicSymlink "$static/$fn", $target or warn;
    }
}

find(\&link, $etc);


# Delete files that were copied in a previous version but not in the
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
write_file("/etc/.clean", map { "$_\n" } @copied);
