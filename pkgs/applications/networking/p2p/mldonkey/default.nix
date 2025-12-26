{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  ocamlPackages,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "mldonkey";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "ygrek";
    repo = "mldonkey";
    tag = "release-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-Dbb7163CdqHY7/FJY2yWBFRudT+hTFT6fO4sFgt6C/A=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  postPatch = ''
    substituteInPlace config/Makefile.in \
      --replace-fail '+camlp4' '${ocamlPackages.camlp4}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/camlp4'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    ocamlPackages.camlp4
    ocamlPackages.findlib
    ocamlPackages.ocaml
    pkg-config
  ];

  buildInputs = [
    ocamlPackages.num
    zlib
  ];

  preAutoreconf = ''
    cd config
  '';

  postAutoreconf = ''
    cd ..
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  }
  # https://github.com/ygrek/mldonkey/issues/117
  // lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = "-std=c++98";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = "https://github.com/ygrek/mldonkey";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
