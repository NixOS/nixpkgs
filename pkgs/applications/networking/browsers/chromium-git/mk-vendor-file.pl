#!/usr/bin/env nix-shell
#!nix-shell -i perl -p perl nix git python2 perlPackages.FileSlurp nix-prefetch-git

use strict;
use warnings;
use Cwd;
use File::Fetch;
use File::Basename  qw(dirname basename);
use File::Path      qw(make_path remove_tree);
use File::Slurp     qw(read_file write_file edit_file);

 # dir to store checked out sources, not $(mktemp -d) because persistency allows reusing files from previous runs
my $basedir = "/tmp/z";

sub checkout {
  my ($url, $rev, $dir) = @_;
  $dir ||= "$basedir/$rev";

  die "already exist $dir" if -e $dir;

  system('nix-prefetch-git',
         '--builder',
         '--url', $url,
         '--out', "$dir.$$", # unique name to allow concurrent runs
         '--rev', $rev,
         '--fetch-submodules') == 0 or die;

  my $hash = `nix hash-path --base32 --type sha256 $dir.$$` =~ s|\s+$||r;
  die "bad hash `$hash'" unless $hash =~ /^[0-9a-z]{52}$/;
  rename("$dir.$$", $dir); # ignore error
  return $hash;
}

sub make_vendor_file {
  my $version = shift;
  my $topdir = "$basedir/$version";

  # first checkout depot_tools for gclient.py which will help to produce list of deps
  unless (-d "$topdir/depot_tools") {
    my $hash = checkout("https://chromium.googlesource.com/chromium/tools/depot_tools",
                        "refs/heads/master",
                        "$topdir/depot_tools");
  }

  # like checkout() but do not delete .git (gclient expects it) and do not compute hash
  # this subdirectory must have "src" name for 'gclient.py' recognises it
  my $old = getcwd();
  unless (-d "$topdir/src") {
    make_path("$topdir/src") or die "make_path($topdir/src): $!";
    chdir("$topdir/src");
    system("git init"                                                                    ) == 0 or die;
    system("git remote add origin \"https://chromium.googlesource.com/chromium/src.git\"") == 0 or die;
    system("git fetch --progress --depth 1 origin \"+$version\""                         ) == 0 or die;
    system("git checkout FETCH_HEAD"                                                     ) == 0 or die;
  } else {
    # restore $topdir into virgin state
    chdir("$topdir/src");
    if (read_file(".git/FETCH_HEAD") =~ /tag '\Q$version\E' of/) {
      print("already at $version\n");
    } else {
      print("git fetch --progress --depth 1 origin \"+$version\"\n");
      system("git fetch --progress --depth 1 origin \"+$version\""                       ) == 0 or die;
      system("git checkout FETCH_HEAD"                                                   ) == 0 or die;
    }
    # and remove all symlinks to subprojects, so their DEPS files won;t be included
    system("find . -name .gitignore -delete"                                             ) == 0 or die;
    system("git status -u -s | grep -v '^ D ' | cut -c4- | xargs --delimiter='\\n' rm"   );
    system("git checkout -f HEAD"                                                        ) == 0 or die;
  }
  chdir($old);


  my $need_another_iteration;
  my %deps;
  do {
    $need_another_iteration = 0;
    my $old = getcwd();
    chdir($topdir);

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
      $url =~ s|^\Qhttps://chromium.googlesource.com/external/github.com/google/EarlGrey\E|https://github.com/google/EarlGrey|;  # some commits are not on the mirror (https://groups.google.com/a/chromium.org/forum/#!topic/chromium-dev/m6xJJhsGrLI)
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
          if (-e "$topdir/$path") { # do not let `symtree_link` to do merge
            remove_tree("$topdir/$path") or die "remove_tree($topdir/$path): $!";
          }
          make_path(dirname("$topdir/$path")) or die unless -e dirname("$topdir/$path");
          system("cp -al $basedir/$rev $topdir/$path") == 0 or die;
        }
        if (-f "$basedir/$rev/DEPS") {  # new DEPS file appeared after checkout
          print("need_another_iteration\n");
          $need_another_iteration = 1;
        }
        $deps{$path} = { rev => $rev, hash => $hash, path => $path, url => $url };
      }
    }
    chdir($old);
  } while ($need_another_iteration);

  open(my $vendor_nix, ">vendor-$version.nix") or die;
  binmode $vendor_nix;
  print $vendor_nix "# GENERATED BY '$0 $version'\n";
  print $vendor_nix "{fetchgit, fetchurl, buildPackages, runCommand}:\n";
  print $vendor_nix "{\n";
  for my $k (sort (keys %deps)) {
    my $dep = $deps{$k};
    printf $vendor_nix "  %-90s = fetchgit { url = %-128s; rev = \"$dep->{rev}\"; sha256 = \"$dep->{hash}\"; };\n", "\"$dep->{path}\"", "\"$dep->{url}\"";
  }

  if (-f "$topdir/src/buildtools/linux64/gn.sha1") {
    my $gn_sha = read_file("$topdir/src/buildtools/linux64/gn.sha1") =~ s|\s+$||r;
    print $vendor_nix qq[
  "src/buildtools/linux64/gn" = {
    "x86_64-linux" = buildPackages.stdenv.mkDerivation {
      name = "gn";
      buildCommand = ''
        install -Dm755 \${fetchurl { url = "https://commondatastorage.googleapis.com/chromium-gn/$gn_sha"; sha1 = "$gn_sha"; }} \$out
        patchelf --set-interpreter \$(cat \$NIX_CC/nix-support/dynamic-linker) \\
                 --set-rpath \${buildPackages.gcc.cc.lib}/lib \\
                 \$out
      '';
    };
  }.\${buildPackages.stdenv.system};
];
  } else {
    my ($gn_version) = read_file("$topdir/src/buildtools/DEPS") =~ /'gn_version': 'git_revision:([0-9a-f]{40})/;
    print("gn_version=$gn_version\n");
    remove_tree("$topdir/gn");
    my $hash = checkout("https://gn.googlesource.com/gn",
                        $gn_version,
                        "$topdir/gn");


    print $vendor_nix qq[
  "src/buildtools/linux64/gn" =
    let
      rev = "$gn_version";
      revNum = "1718"; # FIXME: `git describe HEAD --match initial-commit | cut -d- -f3`
      revShort = builtins.substring 0 7 rev;
      lastCommitPosition = buildPackages.writeText "last_commit_position.h" ''
        #ifndef OUT_LAST_COMMIT_POSITION_H_
        #define OUT_LAST_COMMIT_POSITION_H_

        #define LAST_COMMIT_POSITION_NUM \${revNum}
        #define LAST_COMMIT_POSITION "\${revNum} (\${revShort})"

        #endif  // OUT_LAST_COMMIT_POSITION_H_
      '';

    in buildPackages.stdenv.mkDerivation {
      name = "gn";
      src = fetchgit {
        url = "https://gn.googlesource.com/gn";
        inherit rev;
        sha256 = "$hash";
      };
      nativeBuildInputs = [ buildPackages.ninja buildPackages.python3 ];
      buildPhase = ''
        python build/gen.py --no-last-commit-position
        ln -s \${lastCommitPosition} out/last_commit_position.h
        ninja  -C out gn
      '';
      installPhase = ''
        install -Dm755 out/gn \$out
      '';
    };
];
  }

  my ($node_version) = read_file("$topdir/src/third_party/node/README.chromium") =~ /Version: ([0-9.]+)/;
  print("node_version=$node_version\n");
  File::Fetch->new(uri => "https://nodejs.org/dist/v$node_version/SHASUMS256.txt")->fetch(to => "$basedir/node-$node_version") unless -f "$basedir/node-$node_version/SHASUMS256.txt";
  my %filehashes = map { my ($hash, $name) = /^([0-9a-f]{64})\s+(.+)$/; $name => $hash } read_file("$basedir/node-$node_version/SHASUMS256.txt");

  print $vendor_nix q[
  "src/third_party/node/linux/node-linux-x64" = {
];
  my %filenames = ("x86_64-linux"  => "node-v$node_version-linux-x64.tar.gz",
                   "i686-linux"    => "node-v$node_version-linux-x86.tar.gz",
                   "aarch64-linux" => "node-v$node_version-linux-arm64.tar.gz",
                   "armv7l-linux"  => "node-v$node_version-linux-armv7l.tar.gz");
  for my $system (sort keys %filenames) {
    my $filename = $filenames{$system};
    unless (exists $filehashes{$filename}) {
      # there is no i686-linux binary packages on https://nodejs.org/dist/ since version 10
      # fallback to nixpkgs's version (which is not guaranteed to exist in given <nixpkgs>)
      print $vendor_nix qq[
    "$system" = buildPackages.nodejs-].($node_version =~ s/\..*$//r)."_x;\n";
    } else {
      print $vendor_nix qq[
    "$system" = buildPackages.stdenv.mkDerivation {
      pname = "nodejs-bin";
      version = "$node_version";
      src = fetchurl {
        url = "https://nodejs.org/dist/v$node_version/$filename";
        sha256 = "$filehashes{$filename}";
      };
      buildCommand = ''
        mkdir \$out
        tar xf \$src --strip-components=1 -C \$out
        patchelf --set-interpreter \$(cat \$NIX_CC/nix-support/dynamic-linker) \\
                 --set-rpath \${buildPackages.gcc.cc.lib}/lib \\
                 \$out/bin/node
      '';
    };
];
    }
  }
  print $vendor_nix q[
  }.${buildPackages.stdenv.system};
];



  my $node_modules_sha = read_file("$topdir/src/third_party/node/node_modules.tar.gz.sha1"    ) =~ s|\s+$||r;
  print $vendor_nix qq[
  "src/third_party/node/node_modules"         = runCommand "download_from_google_storage" {} ''
                                                  mkdir \$out
                                                  tar xf \${fetchurl {
                                                              url  = "https://commondatastorage.googleapis.com/chromium-nodejs/$node_modules_sha";
                                                              sha1 = "$node_modules_sha";
                                                           }} --strip-components=1 -C \$out
                                                '';
];



  if (-f "$topdir/src/third_party/test_fonts/test_fonts.tar.gz.sha1") {
    my $test_fonts_sha   = read_file("$topdir/src/third_party/test_fonts/test_fonts.tar.gz.sha1") =~ s|\s+$||r;
    print $vendor_nix qq[
  "src/third_party/test_fonts/test_fonts"     = runCommand "download_from_google_storage" {} ''
                                                  mkdir \$out
                                                  tar xf \${fetchurl {
                                                              url  = "https://commondatastorage.googleapis.com/chromium-fonts/$test_fonts_sha";
                                                              sha1 = "$test_fonts_sha";
                                                           }} --strip-components=1 -C \$out
                                                '';
];
  }

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
