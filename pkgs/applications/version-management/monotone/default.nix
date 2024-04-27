{ lib, stdenv, fetchFromGitHub, boost, zlib, botan2, libidn
, lua, pcre, sqlite, perl, pkg-config, expect, less
, bzip2, gmp, openssl
, autoreconfHook, texinfo
, fetchpatch
}:

let
  version = "1.1-unstable-2021-05-01";
  perlVersion = lib.getVersion perl;
in

assert perlVersion != "";

stdenv.mkDerivation rec {
  pname = "monotone";
  inherit version;

  #  src = fetchurl {
  #    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.bz2";
  #    sha256 = "124cwgi2q86hagslbk5idxbs9j896rfjzryhr6z63r6l485gcp7r";
  #  };

  # My mirror of upstream Monotone repository
  # Could fetchmtn, but circular dependency; snapshot requested
  # https://lists.nongnu.org/archive/html/monotone-devel/2021-05/msg00000.html
  src = fetchFromGitHub {
    owner = "7c6f434c";
    repo = "monotone-mirror";
    rev = "b30b0e1c16def043d2dad57d1467d5bfdecdb070";
    hash = "sha256:1hfy8vaap3184cd7h3qhz0da7c992idkc6q2nz9frhma45c5vgmd";
  };

  patches = [
    ./monotone-1.1-Adapt-to-changes-in-pcre-8.42.patch
    ./monotone-1.1-adapt-to-botan2.patch
    (fetchpatch {
      name = "rm-clang-float128-hack.patch";
      url = "https://github.com/7c6f434c/monotone-mirror/commit/5f01a3a9326a8dbdae7fc911b208b7c319e5f456.patch";
      revert = true;
      sha256 = "0fzjdv49dx5lzvqhkvk50lkccagwx8h0bfha4a0k6l4qh36f9j7c";
    })
    ./monotone-1.1-gcc-14.patch
  ];

  postPatch = ''
    sed -e 's@/usr/bin/less@${less}/bin/less@' -i src/unix/terminal.cc
  '' + lib.optionalString (lib.versionAtLeast boost.version "1.73") ''
    find . -type f -exec sed -i \
      -e 's/ E(/ internal_E(/g' \
      -e 's/{E(/{internal_E(/g' \
      {} +
  '';

  CXXFLAGS=" --std=c++11 ";

  nativeBuildInputs = [ pkg-config autoreconfHook texinfo ];
  buildInputs = [ boost zlib botan2 libidn lua pcre sqlite expect
    openssl gmp bzip2 perl ];

  postInstall = ''
    mkdir -p $out/share/${pname}-${version}
    cp -rv contrib/ $out/share/${pname}-${version}/contrib
    mkdir -p $out/${perl.libPrefix}/${perlVersion}
    cp -v contrib/Monotone.pm $out/${perl.libPrefix}/${perlVersion}

    patchShebangs "$out/share/monotone"
    patchShebangs "$out/share/${pname}-${version}"

    find "$out"/share/{doc/monotone,${pname}-${version}}/contrib/ -type f | xargs sed -e 's@! */usr/bin/@!/usr/bin/env @; s@! */bin/bash@!/usr/bin/env bash@' -i
  '';

  #doCheck = true; # some tests fail (and they take VERY long)

  meta = with lib; {
    description = "A free distributed version control system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
