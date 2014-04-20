#! /run/current-system/sw/bin/perl -w

use strict;
use XML::Simple;
use File::Basename;
use File::Path;
use File::Copy 'cp';
use IPC::Open2;
use Nix::Store;

my $myDir = dirname($0);

my $tarballsCache = $ENV{'NIX_TARBALLS_CACHE'} // "/tarballs";

my $xml = `nix-instantiate --eval-only --xml --strict '<nixpkgs/maintainers/scripts/find-tarballs.nix>'`;
die "$0: evaluation failed\n" if $? != 0;

my $data = XMLin($xml) or die;

mkpath($tarballsCache);
mkpath("$tarballsCache/md5");
mkpath("$tarballsCache/sha1");
mkpath("$tarballsCache/sha256");

foreach my $file (@{$data->{list}->{attrs}}) {
    my $url = $file->{attr}->{url}->{string}->{value};
    my $algo = $file->{attr}->{type}->{string}->{value};
    my $hash = $file->{attr}->{hash}->{string}->{value};

    if ($url !~ /^http:/ && $url !~ /^https:/ && $url !~ /^ftp:/ && $url !~ /^mirror:/) {
        print STDERR "skipping $url (unsupported scheme)\n";
        next;
    }

    $url =~ /([^\/]+)$/;
    my $fn = $1;

    if (!defined $fn) {
        print STDERR "skipping $url (no file name)\n";
        next;
    }

    if ($fn =~ /[&?=%]/ || $fn =~ /^\./) {
        print STDERR "skipping $url (bad character in file name)\n";
        next;
    }

    if ($fn !~ /[a-zA-Z]/) {
        print STDERR "skipping $url (no letter in file name)\n";
        next;
    }

    if ($fn !~ /[0-9]/) {
        print STDERR "skipping $url (no digit in file name)\n";
        next;
    }

    if ($fn !~ /[-_\.]/) {
        print STDERR "skipping $url (no dash/dot/underscore in file name)\n";
        next;
    }

    my $dstPath = "$tarballsCache/$fn";

    next if -e $dstPath;

    print "downloading $url to $dstPath...\n";

    next if $ENV{DRY_RUN};

    $ENV{QUIET} = 1;
    $ENV{PRINT_PATH} = 1;
    my $fh;
    my $pid = open($fh, "-|", "nix-prefetch-url", "--type", $algo, $url, $hash) or die;
    waitpid($pid, 0) or die;
    if ($? != 0) {
        print STDERR "failed to fetch $url: $?\n";
        last if $? >> 8 == 255;
        next;
    }
    <$fh>; my $storePath = <$fh>; chomp $storePath;

    die unless -e $storePath;

    cp($storePath, $dstPath) or die;

    my $md5 = hashFile("md5", 0, $storePath) or die;
    symlink("../$fn", "$tarballsCache/md5/$md5");

    my $sha1 = hashFile("sha1", 0, $storePath) or die;
    symlink("../$fn", "$tarballsCache/sha1/$sha1");

    my $sha256 = hashFile("sha256", 0, $storePath) or die;
    symlink("../$fn", "$tarballsCache/sha256/$sha256");
}
