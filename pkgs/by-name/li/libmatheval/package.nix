{ lib, stdenv, fetchurl, pkg-config, guile, flex, fetchpatch }:

stdenv.mkDerivation rec {
  version = "1.1.11";
  pname = "libmatheval";

  nativeBuildInputs = [ pkg-config flex ];
  buildInputs = [ guile ];

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/libmatheval/${pname}-${version}.tar.gz";
    sha256 = "474852d6715ddc3b6969e28de5e1a5fbaff9e8ece6aebb9dc1cc63e9e88e89ab";
  };

  # Patches coming from debian package
  # https://packages.debian.org/source/sid/libs/libmatheval
  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/libm/libmatheval/1.1.11%2Bdfsg-5/debian/patches/002-skip-docs.patch";
      hash = "sha256-wjz54FKQq7t9Bz0W3EOu+ZPTt8EcfkMotkZKwlWa09o=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/libm/libmatheval/1.1.11%2Bdfsg-5/debian/patches/003-guile3.0.patch";
      hash = "sha256-H3E/2m4MfQAbjpXbVFyNhikVifi3spVThzaVU5srmjI=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/libm/libmatheval/1.1.11%2Bdfsg-5/debian/patches/disable_coth_test.patch";
      hash = "sha256-9XeMXWDTzELWTPcsjAqOlIzp4qY9yupU+e6r0rJEUS0=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev guile}/include/guile/${guile.effectiveVersion}";
  env.NIX_LDFLAGS = "-L${guile}/lib -lguile-${guile.effectiveVersion}";

  meta = {
    description = "Library to parse and evaluate symbolic expressions input as text";
    longDescription = ''
      GNU libmatheval is a library (callable from C and Fortran) to parse and evaluate symbolic
      expressions input as text. It supports expressions in any number of variables of arbitrary
      names, decimal and symbolic constants, basic unary and binary operators, and elementary
      mathematical functions. In addition to parsing and evaluation, libmatheval can also compute
      symbolic derivatives and output expressions to strings.
    '';
    homepage = "https://www.gnu.org/software/libmatheval/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.unix;
  };
}

