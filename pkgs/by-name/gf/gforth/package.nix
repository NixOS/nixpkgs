{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  autoreconfHook,
  texinfo,
  libffi,
  writableTmpDirAsHomeHook,
}:

let
  swig = callPackage ./swig.nix { };
  bootForth = callPackage ./boot-forth.nix { };
  lispDir = "${placeholder "out"}/share/emacs/site-lisp";
in
stdenv.mkDerivation rec {

  pname = "gforth";
  version = "0.7.9_20251001";

  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = version;
    hash = "sha256-u9snXcFa/YYvITgMBY8FRYyyLFhHCP6hWA5ljwdKGLk=";
  };

  patches = [ ./use-nproc-instead-of-fhs.patch ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    autoreconfHook
    texinfo
    bootForth
    swig
  ];
  buildInputs = [
    libffi
  ];

  passthru = { inherit bootForth; };

  configureFlags = [
    "--with-lispdir=${lispDir}"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "--build=x86_64-apple-darwin"
  ];

  preConfigure = ''
    mkdir -p ${lispDir}
  '';

  meta = {
    description = "Forth implementation of the GNU project";
    homepage = "https://github.com/forthy42/gforth";
    license = lib.licenses.gpl3;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64; # segfault when running ./gforthmi
    platforms = lib.platforms.all;
  };
}
