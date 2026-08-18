{
  lib,
  stdenv,
  fetchFromForgejo,
  botan3,
  boost,
  zlib,
  libidn,
  lua,
  pcre2,
  sqlite,
  perl,
  pkg-config,
  expect,
  less,
  bzip2,
  gmp,
  openssl,
  autoreconfHook,
  texinfo,
  fetchpatch,
  callPackage,
  runCommand,
}:

let
  perlVersion = lib.getVersion perl;
in

assert perlVersion != "";

stdenv.mkDerivation (finalAttrs: {
  pname = "monotone";
  version = "1.1-unstable-2025-12-11";

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  #  src = fetchurl {
  #    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
  #    hash = "sha256-+Vz2CiLU5GG+ydDnL102CcmkV2+xzEX1U9AgLOLjjIg=";
  #  };

  # Upstream developer's mirror for easier access
  # Could fetchmtn, but circular dependency
  src = fetchFromForgejo {
    domain = "git.lapo.it";
    owner = "lapo";
    repo = "monotone";
    rev = "f93a19184e0c6c6ca5842ab050fcd62f2376c4ca";
    hash = "sha256-PT0DfVFDTHIWH1hZlaxpceoG94pytqFbjJvHVpIBNHs=";
  };

  patches = [
    ./monotone-botan-key-format.patch
    ./monotone-1.1-gcc-14.patch
    ./monotone-botan-error-reporting.patch
    ./monotone-pcre2.patch
  ];

  postPatch = ''
    sed -e 's@/usr/bin/less@${less}/bin/less@' -i src/unix/terminal.cc
  ''
  + lib.optionalString (lib.versionAtLeast boost.version "1.73") ''
    find . -type f -exec sed -i \
      -e 's/ E(/ internal_E(/g' \
      -e 's/{E(/{internal_E(/g' \
      {} +
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    texinfo
  ];
  buildInputs = [
    boost
    zlib
    botan3
    libidn
    lua
    pcre2
    sqlite
    expect
    openssl
    gmp
    bzip2
    perl
  ];

  env.NIX_LDFLAGS = " -lpcre2-8 ";

  postInstall = ''
    mkdir -p $out/share/monotone-${finalAttrs.version}
    cp -rv contrib/ $out/share/monotone-${finalAttrs.version}/contrib
    mkdir -p $out/${perl.libPrefix}/${perlVersion}
    cp -v contrib/Monotone.pm $out/${perl.libPrefix}/${perlVersion}

    patchShebangs "$out/share/monotone"
    patchShebangs "$out/share/monotone-${finalAttrs.version}"

    find "$out"/share/{doc/monotone,monotone-${finalAttrs.version}}/contrib/ -type f | xargs sed -e 's@! */usr/bin/@!/usr/bin/env @; s@! */bin/bash@!/usr/bin/env bash@' -i
  '';

  #doCheck = true; # some tests fail (and they take VERY long)

  passthru.tests = {
    basicEndToEnd =
      runCommand "monotone-test-end-to-end" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          mkdir -p "$out/share/monotone-test/log/"
          target="$out/share/monotone-test/log/monotone-test-end-to-end.log"

          (
            export HOME="$PWD"
            set -x

            mtn genkey test@localhost

            mkdir a b c

            mtn -d :test1 db init
            mtn -d :test2 db init

            (
              cd a
              mtn -d :test1 -b test setup
              echo 123 > aaa
              mtn add aaa
              mtn ci -m 'add aaa'
              mtn log
            )

            (
              cd b
              mtn -d :test2 sync file:///$HOME/.monotone/databases/test1.mtn'?*'
              mtn -d :test2 co -r h:test -b test .
              mtn up
              echo 456 > bbb
              mtn add bbb
              mtn ci -m 'add bbb'
              mtn log
            )

            (
              cd a
              echo 789 > ccc
              mtn add ccc
              mtn ci -m 'add ccc'
              mtn log
            )

            (
              cd c
              mtn -d :test1 sync file:///$HOME/.monotone/databases/test2.mtn'?*'
              mtn -d :test1 merge -b test
              mtn -d :test1 co -r h:test -b test .
              mtn up
              mtn log
              cat aaa bbb ccc | xargs | grep '123 456 789'
            )

          ) 2>&1 | tee "$target"
        '';
    packageTests-unit = finalAttrs.finalPackage.overrideAttrs {
      pname = "monotone-test";
      doCheck = true;
      buildPhase = " cp -iv ${finalAttrs.finalPackage}/bin/* . ";
      installPhase = " true; ";
      postCheck = " touch $out; ";
      checkPhase = ''
        runHook preCheck

        make test/unit.status -j $NIX_CORES

        runHook postCheck
        grep '^0$' test/unit.status
      '';
    };
    packageTests-func = finalAttrs.finalPackage.overrideAttrs {
      pname = "monotone-test";
      doCheck = true;
      nativeBuildInputs = finalAttrs.nativeBuildInputs ++ [ finalAttrs.finalPackage ];
      buildPhase = " cp -iv ${finalAttrs.finalPackage}/bin/* . ";
      installPhase = " true; ";
      postCheck = " touch $out; ";
      checkPhase = ''
        runHook preCheck

        make test/func.status -j $NIX_CORES

        runHook postCheck
        grep '^0$' test/func.status || {
          cat test/work/*.log
          exit 1
        }
      '';
      preCheck = ''
        sed -e 's@test/func.status *: *mtn$(EXEEXT)@test/func.status : @' -i Makefile*
      '';
      patches = (finalAttrs.patches or [ ]) ++ [
        ./monotone-test-passphrase-botan3.patch
        ./monotone-test-nop-migration.patch
        ./monotone-base64-error-reporting.patch
        ./monotone-test-pcre2-mtnignore.patch
      ];
    };
  };

  meta = {
    description = "Free distributed version control system";
    homepage = "https://git.lapo.it/lapo/monotone";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
