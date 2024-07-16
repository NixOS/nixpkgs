#! /usr/bin/env nix-shell
#! nix-shell -i perl -p perl perlPackages.NetAmazonS3 perlPackages.FileSlurp perlPackages.JSON perlPackages.LWPProtocolHttps nix nix.perl-bindings

# This command uploads tarballs to tarballs.nixos.org, the
# content-addressed cache used by fetchurl as a fallback for when
# upstream tarballs disappear or change. Usage:
#
# 1) To upload one or more files:
#
#    $ copy-tarballs.pl --file /path/to/tarball.tar.gz
#
# 2) To upload all files obtained via calls to fetchurl in a Nix derivation:
#
#    $ copy-tarballs.pl --expr '(import <nixpkgs> {}).hello'

use strict;
use warnings;
use File::Basename;
use File::Path;
use File::Slurp;
use JSON;
use Net::Amazon::S3;
use Nix::Store;

isValidPath("/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-foo"); # FIXME: forces Nix::Store initialisation

sub usage {
    die "Syntax: $0 [--dry-run] [--exclude REGEXP] [--expr EXPR | --file FILES...]\n";
}

my $dryRun = 0;
my $expr;
my @fileNames;
my $exclude;

while (@ARGV) {
    my $flag = shift @ARGV;

    if ($flag eq "--expr") {
        $expr = shift @ARGV or die "--expr requires an argument";
    } elsif ($flag eq "--file") {
        @fileNames = @ARGV;
        last;
    } elsif ($flag eq "--dry-run") {
        $dryRun = 1;
    } elsif ($flag eq "--exclude") {
        $exclude = shift @ARGV or die "--exclude requires an argument";
    } else {
        usage();
    }
}

my $bucket;

if (not defined $ENV{DEBUG}) {
    # S3 setup.
    my $aws_access_key_id = $ENV{'AWS_ACCESS_KEY_ID'} or die "AWS_ACCESS_KEY_ID not set\n";
    my $aws_secret_access_key = $ENV{'AWS_SECRET_ACCESS_KEY'} or die "AWS_SECRET_ACCESS_KEY not set\n";

    my $s3 = Net::Amazon::S3->new(
        { aws_access_key_id     => $aws_access_key_id,
          aws_secret_access_key => $aws_secret_access_key,
          retry                 => 1,
          host                  => "s3-eu-west-1.amazonaws.com",
        });

    $bucket = $s3->bucket("nixpkgs-tarballs") or die;
}

my $doWrite = 0;
my $cacheFile = ($ENV{"HOME"} or die "\$HOME is not set") . "/.cache/nix/copy-tarballs";
my %cache;
$cache{$_} = 1 foreach read_file($cacheFile, err_mode => 'quiet', chomp => 1);
$doWrite = 1;

END() {
    File::Path::mkpath(dirname($cacheFile), 0, 0755);
    write_file($cacheFile, map { "$_\n" } keys %cache) if $doWrite;
}

sub alreadyMirrored {
    my ($algo, $hash) = @_;
    my $key = "$algo/$hash";
    return 1 if defined $cache{$key};
    my $res = defined $bucket->get_key($key);
    $cache{$key} = 1 if $res;
    return $res;
}

sub uploadFile {
    my ($fn, $name) = @_;

    my $md5_16 = hashFile("md5", 0, $fn) or die;
    my $sha1_16 = hashFile("sha1", 0, $fn) or die;
    my $sha256_32 = hashFile("sha256", 1, $fn) or die;
    my $sha256_16 = hashFile("sha256", 0, $fn) or die;
    my $sha512_32 = hashFile("sha512", 1, $fn) or die;
    my $sha512_16 = hashFile("sha512", 0, $fn) or die;

    my $mainKey = "sha512/$sha512_16";

    # Create redirects from the other hash types.
    sub redirect {
        my ($name, $dest) = @_;
        #print STDERR "linking $name to $dest...\n";
        $bucket->add_key($name, "", {
            'x-amz-website-redirect-location' => "/" . $dest,
            'x-amz-acl' => "public-read"
        })
            or die "failed to create redirect from $name to $dest\n";
        $cache{$name} = 1;
    }
    redirect "md5/$md5_16", $mainKey;
    redirect "sha1/$sha1_16", $mainKey;
    redirect "sha256/$sha256_32", $mainKey;
    redirect "sha256/$sha256_16", $mainKey;
    redirect "sha512/$sha512_32", $mainKey;

    # Upload the file as sha512/<hash-in-base-16>.
    print STDERR "uploading $fn to $mainKey...\n";
    $bucket->add_key_filename($mainKey, $fn, {
        'x-amz-meta-original-name' => $name,
        'x-amz-acl' => "public-read"
    })
        or die "failed to upload $fn to $mainKey\n";
    $cache{$mainKey} = 1;
}

if (scalar @fileNames) {
    my $res = 0;
    foreach my $fn (@fileNames) {
        eval {
            if (alreadyMirrored("sha512", hashFile("sha512", 0, $fn))) {
                print STDERR "$fn is already mirrored\n";
            } else {
                uploadFile($fn, basename $fn);
            }
        };
        if ($@) {
            warn "$@";
            $res = 1;
        }
    }
    exit $res;
}

elsif (defined $expr) {

    # Evaluate find-tarballs.nix.
    my $pid = open(JSON, "-|", "nix-instantiate", "--eval", "--json", "--strict",
                   "<nixpkgs/maintainers/scripts/find-tarballs.nix>",
                   "--arg", "expr", $expr);
    my $stdout = <JSON>;
    waitpid($pid, 0);
    die "$0: evaluation failed\n" if $?;
    close JSON;

    my $fetches = decode_json($stdout);

    print STDERR "evaluation returned ", scalar(@{$fetches}), " tarballs\n";

    # Check every fetchurl call discovered by find-tarballs.nix.
    my $mirrored = 0;
    my $have = 0;
    foreach my $fetch (sort { $a->{urls}->[0] cmp $b->{urls}->[0] } @{$fetches}) {
        my $urls = $fetch->{urls};
        my $algo = $fetch->{type};
        my $hash = $fetch->{hash};
        my $name = $fetch->{name};
        my $isPatch = $fetch->{isPatch};

        if ($isPatch) {
            print STDERR "skipping $urls->[0] (support for patches is missing)\n";
            next;
        }

        if ($hash =~ /^([a-z0-9]+)-([A-Za-z0-9+\/=]+)$/) {
            $algo = $1;
            $hash = `nix hash to-base16 $hash` or die;
            chomp $hash;
        }

        next unless $algo =~ /^[a-z0-9]+$/;

        # Convert non-SRI base-64 to base-16.
        if ($hash =~ /^[A-Za-z0-9+\/=]+$/) {
            $hash = `nix hash to-base16 --type '$algo' $hash` or die;
            chomp $hash;
        }

        my $storePath = makeFixedOutputPath(0, $algo, $hash, $name);

        for my $url (@$urls) {
            if (defined $ENV{DEBUG}) {
                print "$url $algo $hash\n";
                next;
            }

            if ($url !~ /^http:/ && $url !~ /^https:/ && $url !~ /^ftp:/ && $url !~ /^mirror:/) {
                print STDERR "skipping $url (unsupported scheme)\n";
                next;
            }

            next if defined $exclude && $url =~ /$exclude/;

            if (alreadyMirrored($algo, $hash)) {
                $have++;
                last;
            }

            print STDERR "mirroring $url ($storePath, $algo, $hash)...\n";

            if ($dryRun) {
                $mirrored++;
                last;
            }

            # Substitute the output.
            if (!isValidPath($storePath)) {
                system("nix-store", "-r", $storePath);
            }

            # Otherwise download the file using nix-prefetch-url.
            if (!isValidPath($storePath)) {
                $ENV{QUIET} = 1;
                $ENV{PRINT_PATH} = 1;
                my $fh;
                my $pid = open($fh, "-|", "nix-prefetch-url", "--type", $algo, $url, $hash) or die;
                waitpid($pid, 0) or die;
                if ($? != 0) {
                    print STDERR "failed to fetch $url: $?\n";
                    next;
                }
                <$fh>; my $storePath2 = <$fh>; chomp $storePath2;
                if ($storePath ne $storePath2) {
                    warn "strange: $storePath != $storePath2\n";
                    next;
                }
            }

            uploadFile($storePath, $url);
            $mirrored++;
            last;
        }
    }

    print STDERR "mirrored $mirrored files, already have $have files\n";
}

else {
    usage();
}
