{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  autoreconfHook,
  gitUpdater,
  texinfo,
  libffi,
  writableTmpDirAsHomeHook,
}:

let
  swig = buildPackages.callPackage ./swig.nix { };
  bootForth = buildPackages.callPackage ./boot-forth.nix { };
  lispDir = "${placeholder "out"}/share/emacs/site-lisp";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gforth";
  version = "0.7.9_20260410";

  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = finalAttrs.version;
    hash = "sha256-Nb5CB2k7gfG3sT+zfHGmj9G/CGccIvSIKcOuP7Altn0=";
  };

  patches = [ ./use-nproc-instead-of-fhs.patch ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    autoreconfHook
    texinfo
    swig
  ]
  ++ (
    if (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) then
      [ buildPackages.gforth ]
    else
      [ bootForth ]
  );

  buildInputs = [
    libffi
  ];

  passthru = { inherit bootForth; };

  configureFlags = [
    "--with-lispdir=${lispDir}"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "--build=x86_64-apple-darwin"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # Tries to run ./engine/gforth-ll
    "--without-check"
    # Use build-platform CC for helper programs that must run during build
    "HOSTCC=${buildPackages.stdenv.cc}/bin/cc"
    # Tell gforth's libcc where to find the cross compiler
    "CROSS_PREFIX=${stdenv.hostPlatform.config}-"
  ];

  env = lib.optionalAttrs (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    # Tell gforth's libcc to prefix compiler commands with the cross-compilation target
    CROSS_PREFIX = "${stdenv.hostPlatform.config}-";
  };

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "DITCENGINE=${buildPackages.gforth}/bin/gforth-ditc"
    "GFORTH=${buildPackages.gforth}/bin/gforth"
    "ENGINE=${buildPackages.gforth}/bin/gforth" # for ./preforth
  ];

  preConfigure = ''
    mkdir -p ${lispDir}
  '';

  postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Put the project-local (cross-aware) libtool first in PATH
    mkdir -p .cross-bin
    ln -sf "$PWD/libtool" .cross-bin/libtool
    ln -sf "$PWD/libtool" ".cross-bin/${stdenv.hostPlatform.config}-libtool"
    export PATH="$PWD/.cross-bin:$PATH"
    # Remove 'check' from the default 'all' target (can't run cross binaries)
    sed -i 's/^\(all:.*\) check/\1/' Makefile
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
    maintainers = with lib.maintainers; [ rafaelrc ];
  };
})
