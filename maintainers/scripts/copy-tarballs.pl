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
    my $fetchType = $file->{attr}->{fetchType}->{string}->{value};
    my $fetchArguments = $file->{attr}->{fetchArguments}->{attrs};
    my $url = $fetchArguments->{attr}->{url}->{string}->{value};
    my $hash = $fetchArguments->{attr}->{hash}->{string}->{value};

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

    my $dstPath = "$tarballsCache/$fetchType/$hash";

    next if -e $dstPath;

    print "downloading $url to $dstPath...\n";

    next if $ENV{DRY_RUN};

    $ENV{QUIET} = 1;
    $ENV{PRINT_PATH} = 1;
    my $fh;
    my %nixPrefetch = (
        "url" =>
          sub {
            local $algo = $fetchArguments->{attr}->{algo}->{string}->{value};
            return open($fh, "-|", "nix-prefetch-url", "--type", $algo, $url, $hash) or die;
          },
        "git" =>
          sub {
            local $out = "--out " ++ $fetchArguments->{attr}->{out}->{string}->{value};
            local $rev = "--rev " ++ $fetchArguments->{attr}->{ref}->{string}->{value};
            local $leaveDotGit = if ($fetchArguments->{attr}->{leaveDotGit}->{bool}->{value} == 1) "--leave-dotGit" else "";
            local $deepClone = if ($fetchArguments->{attr}->{deepClone}->{bool}->{value} == 1) "--deepClone" else "";
            local $fetchSubmodules = if ($fetchArguments->{attr}->{fetchSubmodules}->{bool}->{value} == 1) "--fetch-submodules" else "";
            local $branchName = if ($fetchArguments->{attr}->{branchName}->{string}->{value} != "") "--branch-name $fetchArguments->{attr}->{branchName}->{string}->{value}" else "";
            return open($fh, "-|", "nix-prefetch-git", "--builder", "--url", $url, "--hash", $hash, $out, $rev, $leaveDotGit, $deepClone, $fetchSubmodules, $branchName ) or die;
          }
    );
    my $pid = $nixPrefetch{$fetchType};
    waitpid($pid, 0) or die;
    if ($? != 0) {
        print STDERR "failed to fetch $url: $?\n";
        next;
    }
    <$fh>; my $storePath = <$fh>; chomp $storePath;

    die unless -e $storePath;

    `tar -cJf $dstPath -C $(dirname $storePath) $storePath` or die;

}
