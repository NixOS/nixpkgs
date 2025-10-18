{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "figlet";
  version = "2.2.5";

  # some tools can be found here ftp://ftp.figlet.org/pub/figlet/util/
  src = fetchurl {
    url = "ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-v4jED9Dwd9qycS9U+NOayVLk6fLhiC8Rlb6eXkJXQX0=";
  };

  contributed = fetchzip {
    url = "ftp://ftp.figlet.org/pub/figlet/fonts/contributed.tar.gz";
    hash = "sha256-AyvAoc3IqJeKWgJftBahxb/KJjudeJIY4KD6mElNagQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/figlet/musl-fix-cplusplus-decls.patch?h=3.4-stable&id=71776c73a6f04b6f671430f702bcd40b29d48399";
      name = "musl-fix-cplusplus-decls.patch";
      hash = "sha256-8tg/3rBnjFG2Q4W807+Z0NpTO7VZrontn6qm6fL7QJw=";
    })
    (fetchpatch {
      url = "https://github.com/cmatsuoka/figlet/commit/9a50c1795bc32e5a698b855131ee87c8d7762c9e.patch";
      name = "unistd-on-darwin.patch";
      hash = "sha256-hyfY87N+yuAwjsBIjpgvcdJ1IbzlR4A2yUJQSzShCRI=";
    })
  ];

  makeFlags = [
    "prefix=$(out)"
    "CC:=$(CC)"
    "LD:=$(CC)"
  ];

  postInstall = "cp -ar ${finalAttrs.contributed}/* $out/share/figlet/";

  doCheck = true;

  meta = {
    description = "Program for making large letters out of ordinary text";
    homepage = "http://www.figlet.org/";
    license = lib.licenses.afl21;
    platforms = lib.platforms.unix;
    mainProgram = "figlet";
  };
})
