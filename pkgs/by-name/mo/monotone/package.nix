{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  zlib,
  libidn,
  lua,
  pcre,
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
}:

let
  perlVersion = lib.getVersion perl;

  botan = callPackage ./botan2.nix { enableForMonotone = true; };
in

assert perlVersion != "";

stdenv.mkDerivation (finalAttrs: {
  pname = "monotone";
  version = "1.1-unstable-2021-05-01";

  strictDeps = true;
  __structuredAttrs = true;

  #  src = fetchurl {
  #    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
  #    hash = "sha256-+Vz2CiLU5GG+ydDnL102CcmkV2+xzEX1U9AgLOLjjIg=";
  #  };

  # My mirror of upstream Monotone repository
  # Could fetchmtn, but circular dependency; snapshot requested
  # https://lists.nongnu.org/archive/html/monotone-devel/2021-05/msg00000.html
  src = fetchFromGitHub {
    owner = "7c6f434c";
    repo = "monotone-mirror";
    rev = "b30b0e1c16def043d2dad57d1467d5bfdecdb070";
    hash = "sha256-rb5dWCGqwuzStwIbNlsUKbGjGvgQD3gaIyiMq9RG3sE=";
  };

  patches = [
    ./monotone-1.1-Adapt-to-changes-in-pcre-8.42.patch
    ./monotone-1.1-adapt-to-botan2.patch
    (fetchpatch {
      name = "rm-clang-float128-hack.patch";
      url = "https://github.com/7c6f434c/monotone-mirror/commit/5f01a3a9326a8dbdae7fc911b208b7c319e5f456.patch";
      revert = true;
      hash = "sha256-7MjkzICYUDOBIgq6BSDq/CnGJgVl7gnx/rT0lshu8js=";
    })
    ./monotone-1.1-gcc-14.patch
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

  env.CXXFLAGS = " --std=c++11 ";

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    texinfo
  ];
  buildInputs = [
    boost
    zlib
    botan
    libidn
    lua
    pcre
    sqlite
    expect
    openssl
    gmp
    bzip2
    perl
  ];

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

  meta = {
    description = "Free distributed version control system";
    homepage = "https://github.com/7c6f434c/monotone-mirror";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
