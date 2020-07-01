#!/usr/bin/env nix-shell
#!nix-shell -i perl -p perl perlPackages.LWPProtocolhttps perlPackages.FileSlurp

use strict;
use List::Util qw(reduce);
use File::Slurp;
use LWP::Simple;

sub semantic_less {
  my ($a, $b) = @_;
  $a =~ s/\b(\d+)\b/sprintf("%010s", $1)/eg;
  $b =~ s/\b(\d+)\b/sprintf("%010s", $1)/eg;
  return $a lt $b;
}

sub get_latest_versions {
  my @channels = get("http://www.jetbrains.com/updates/updates.xml") =~ /(<channel .+?<\/channel>)/gs;
  my %h = {};
  for my $ch (@channels) {
    my ($id) = $ch =~ /^<channel id="[^"]+" name="([^"]+)"/;
    my @builds = $ch =~ /(<build .+?<\/build>)/gs;
    my $latest_build = reduce {
      my ($aversion) = $a =~ /^<build [^>]*version="([^"]+)"/; die "no version in $a" unless $aversion;
      my ($bversion) = $b =~ /^<build [^>]*version="([^"]+)"/; die "no version in $b" unless $bversion;
      semantic_less($aversion, $bversion) ? $b : $a;
    } @builds;
    next unless $latest_build;

    # version as in download url
    my ($version) = $latest_build =~ /^<build [^>]*version="([^"]+)"/;
    my ($fullNumber) = $latest_build =~ /^<build [^>]*fullNumber="([^"]+)"/;
    my $latest_version_full1 = "$version-$fullNumber";
    $latest_version_full1 =~ s/\s*EAP//;

    my ($latest_version) = $latest_build =~ /^<build [^>]*version="([^"]+)"/;
    ($latest_version) = $latest_build =~ /^<build [^>]*fullNumber="([^"]+)"/ if $latest_version =~ / /;

    $h{$id} = $latest_version;
    $h{"full1_" . $id} = $latest_version_full1;
  }
  return %h;
}

my %latest_versions = get_latest_versions();
# for my $ch (sort keys %latest_versions) {
#  print("$ch $latest_versions{$ch}\n");
# }

sub update_nix_block {
  my ($block) = @_;
  my ($channel) = $block =~ /update-channel\s*=\s*"([^"]+)"/;
  if ($channel) {
    if ($latest_versions{$channel}) {
      my ($version) = $block =~ /version\s*=\s*"([^"]+)"/;
      die "no version in $block" unless $version;
      if ($version eq $latest_versions{$channel}) {
        print("$channel is up to date at $version\n");
      } else {
        print("updating $channel: $version -> $latest_versions{$channel}\n");
        my ($url) = $block =~ /url\s*=\s*"([^"]+)"/;
        # try to interpret some nix
        my ($name) = $block =~ /name\s*=\s*"([^"]+)"/;
        $name =~ s/\$\{version\}/$latest_versions{$channel}/;
        $url =~ s/\$\{name\}/$name/;
        $url =~ s/\$\{version\}/$latest_versions{$channel}/;
        die "$url still has some interpolation" if $url =~ /\$/;
        my ($sha256) = get("$url.sha256") =~ /^([0-9a-f]{64})/;
        my $version_string = $latest_versions{$channel};
        unless ( $sha256 ) {
          my $full_version = $latest_versions{"full1_" . $channel};
          $url =~ s/$version_string/$full_version/;
          ($sha256) = get("$url.sha256") =~ /^([0-9a-f]{64})/;
          $version_string = $full_version;
        }
        die "invalid sha256 in $url.sha256" unless $sha256;
        my ($sha256Base32) = readpipe("nix-hash --type sha256 --to-base32 $sha256");
        chomp $sha256Base32;
        print "Jetbrains published SHA256: $sha256\n";
        print "Conversion into base32 yields: $sha256Base32\n";
        $block =~ s#version\s*=\s*"([^"]+)".+$#version = "$version_string"; /* updated by script */#m;
        $block =~ s#sha256\s*=\s*"([^"]+)".+$#sha256 = "$sha256Base32"; /* updated by script */#m;
      }
    } else {
      warn "unknown update-channel $channel";
    }
  }
  return $block;
}

my $nix = read_file 'default.nix';
$nix =~ s/(= build\w+ rec \{.+?\n  \};\n)/update_nix_block($1)/gse;
write_file 'default.nix', $nix;
