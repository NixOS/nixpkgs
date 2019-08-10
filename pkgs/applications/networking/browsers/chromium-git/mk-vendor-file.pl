#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=/run/current-system/nixpkgs -i perl -p perl nix git python2 perlPackages.FileSlurp

use strict;
use warnings;
use Cwd;
use File::Basename  qw(dirname basename);
use File::Path      qw(make_path remove_tree);
use File::Slurp     qw(read_file write_file edit_file);

 # dir to store checked out sources, not $(mktemp -d) because persistency allows reusing files from previous runs
my $basedir = "/tmp/z";

# get <nixpkgs>
my ($nixpkgs) = $ENV{NIX_PATH} =~ /\bnixpkgs(?:-current)?=([^:]+)/;
print("<nixpkgs> found at '$nixpkgs'\n");
die unless -f "$nixpkgs/pkgs/build-support/fetchgit/nix-prefetch-git";

sub checkout {
  my ($url, $rev, $dir) = @_;
  $dir ||= "$basedir/$rev";

  die "already exist $dir" if -e $dir;

  system('perl', "$nixpkgs/pkgs/build-support/fetchgit/nix-prefetch-git",
         '--builder',
         '--url', $url,
         '--out', $dir,
         '--rev', $rev,
         '--fetch-submodules') == 0 or die;

  my $hash = `nix hash-path --base32 --type sha256 $dir` =~ s|\s+$||r;
  die "bad hash `$hash'" unless $hash =~ /^[0-9a-z]{52}$/;
  return $hash;
}

sub make_vendor_file {
  my $version = shift;

  # first checkout depot_tools for gclient.py which will help to produce list of deps
  unless (-d "$basedir/depot_tools") {
    my $hash = checkout("https://chromium.googlesource.com/chromium/tools/depot_tools", "a110bf60c043d93a23c105215f000b88a2825c49", "$basedir/depot_tools");
  }

  # like checkout() but do not delete .git (gclient expects it) and do not compute hash
  # this subdirectory must have "src" name for 'gclient.py' recognises it
  my $top = getcwd();
  unless (-d "$basedir/src/.git") {
    make_path("$basedir/src") or die "make_path($basedir/src): $!";
    chdir("$basedir/src");
    system("git init"                                                                    ) == 0 or die;
    system("git remote add origin \"https://chromium.googlesource.com/chromium/src.git\"") == 0 or die;
    system("git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
    system("git checkout FETCH_HEAD"                                                     ) == 0 or die;
  } else {
    chdir("$basedir/src");
    if (read_file(".git/FETCH_HEAD") =~ /tag '\Q$version\E' of/) {
      print("already at $version\n");
    } else {
      print("git fetch --progress --depth 1 origin \"+$version\"\n");
      system("git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
      system("git checkout FETCH_HEAD"                                                     ) == 0 or die;
    }
    # and remove all symlinks to subprojects, so their DEPS files won;t be included
    system("find . -name .gitignore -exec rm {} \\;");
    system("git status -u -s | cut -c4- | xargs --delimiter='\\n' rm");
    system("git checkout -f HEAD");
  }
  chdir($top);


  my $need_another_iteration;
  my %deps;
  do {
    $need_another_iteration = 0;
    my $top = getcwd();
    chdir($basedir);

    # flatten fail because of duplicate valiable names, so rename them
    if (-f 'src/third_party/angle/buildtools/DEPS') {
      edit_file {
        s/\b(libcxx_revision)\b/${1}2/g;
        s/\b(libcxxabi_revision)\b/${1}2/g;
        s/\b(libunwind_revision)\b/${1}2/g;
      } 'src/third_party/angle/buildtools/DEPS';
    }

    system("python2 depot_tools/gclient.py config https://chromium.googlesource.com/chromium/src.git") == 0 or die;
    system("python2 depot_tools/gclient.py flatten -v --pin-all-deps > flat"                         ) == 0 or die;

    my $content = read_file('flat');
    while ($content =~ /"([^"]+)":\s*\{\s*"url":\s*"(.+)@(.+)"/gm) {
      my $url = $2;
      my $rev = $3;
      my $path = $1 =~ s|\\|/|gr;
      next if $url =~ /chrome-internal\.googlesource\.com/; # access denied to this domain
      if (!exists($deps{$path})) {
        print("path=$path url=$url rev=$rev\n");
        my $hash;
        if (-e "$basedir/$rev" && -e "$basedir/$rev.sha256") { # memoize $hash in "$basedir/$rev.sha256"
          $hash = read_file("$basedir/$rev.sha256");
        } else {
          remove_tree("$basedir/$rev", "$basedir/$rev.sha256");
          $hash = checkout($url, $rev, "$basedir/$rev");
          write_file("$basedir/$rev.sha256", $hash);
        }
        if ($path ne 'src') {
          die "$basedir/$rev does not exist" unless -d "$basedir/$rev";
          if (-e "$basedir/$path") { # do not let `symtree_link` to do merge
            remove_tree("$basedir/$path") or die "remove_tree($basedir/$path): $!";
          }
          make_path(dirname("$basedir/$path")) or die unless -e dirname("$basedir/$path");
          system("cp -al $basedir/$rev $basedir/$path") == 0 or die;
        }
        if (-f "$basedir/$rev/DEPS") {  # new DEPS file appeared after checkout
          print("need_another_iteration\n");
          $need_another_iteration = 1;
        }
        $deps{$path} = { rev => $rev, hash => $hash, path => $path, url => $url };
      }
    }
    chdir($top);
  } while ($need_another_iteration);

  open(my $vendor_nix, ">vendor-$version.nix") or die;
  binmode $vendor_nix;
  print $vendor_nix "# GENERATED BY '$0 $version'\n";
  print $vendor_nix "{fetchgit, fetchurl, runCommand}:\n";
  print $vendor_nix "{\n";
  for my $k (sort (keys %deps)) {
    my $dep = $deps{$k};
    printf $vendor_nix "  %-90s = fetchgit { url = %-128s; rev = \"$dep->{rev}\"; sha256 = \"$dep->{hash}\"; };\n", "\"$dep->{path}\"", "\"$dep->{url}\"";
  }

  my $node_modules_sha = read_file("$basedir/src/third_party/node/node_modules.tar.gz.sha1"    ) =~ s|\s+$||r;
  print $vendor_nix qq[
  "src/third_party/node/node_modules"       = runCommand "download_from_google_storage" {} ''
                                                mkdir \$out
                                                tar xf \${fetchurl {
                                                            url  = "https://commondatastorage.googleapis.com/chromium-nodejs/$node_modules_sha";
                                                            sha1 = "$node_modules_sha";
                                                         }} --strip-components=1 -C \$out
                                              '';];

  my $test_fonts_sha   = read_file("$basedir/src/third_party/test_fonts/test_fonts.tar.gz.sha1") =~ s|\s+$||r;
  print $vendor_nix qq[
  "src/third_party/test_fonts/test_fonts"   = runCommand "download_from_google_storage" {} ''
                                                mkdir \$out
                                                tar xf \${fetchurl {
                                                            url  = "https://commondatastorage.googleapis.com/chromium-fonts/$test_fonts_sha";
                                                            sha1 = "$test_fonts_sha";
                                                         }} --strip-components=1 -C \$out
                                              '';];

  print $vendor_nix "}\n";
  close($vendor_nix);
}


die "\ncall me: '$0 chromium_versions'" unless @ARGV;
for my $version (@ARGV) {
  die "bad version $version" unless $version =~ /^\d+(\.\d+)+$/;
}
for my $version (@ARGV) {
  make_vendor_file($version);
}
