{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  autoreconfHook,
  gitUpdater,
  texinfo,
  libffi,
  writableTmpDirAsHomeHook,
}:

let
  swig = callPackage ./swig.nix { };
  bootForth = callPackage ./boot-forth.nix { };
  lispDir = "${placeholder "out"}/share/emacs/site-lisp";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gforth";
  version = "0.7.9_20251001";

  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = finalAttrs.version;
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

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Forth implementation of the GNU project";
    homepage = "https://www.gnu.org/software/gforth";
    downloadPage = "https://github.com/forthy42/gforth";
    license = lib.licenses.gpl3Plus;
    # segfault when running ./gforthmi on aarch64 darwin
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
    platforms = lib.platforms.all;
    mainProgram = "gforth";
  };
})
