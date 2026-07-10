{
  lib,
  stdenv,
  fetchFromGitHub,
  imake,
  gccmakedep,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  version_name = "1.2.hanami.6";
  version = "1.2.6";
  pname = "oneko";
  src = fetchFromGitHub {
    owner = "IreneKnapp";
    repo = "oneko";
    rev = finalAttrs.version_name;
    sha256 = "0vx12v5fm8ar3f1g6jbpmd3b1q652d32nc67ahkf28djbqjgcbnc";
  };
  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libx11
    libxext
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-function-declaration"
    "-Wno-endif-labels"
    "-Wno-implicit-int"
    "-Wno-incompatible-pointer-types"
  ];

  installTargets = [
    "install"
    "install.man"
  ];

  meta = {
    description = "Creates a cute cat chasing around your mouse cursor";
    longDescription = ''
      Oneko changes your mouse cursor into a mouse
      and creates a little cute cat, which starts
      chasing around your mouse cursor.
      When the cat is done catching the mouse, it starts sleeping.
    '';
    homepage = "https://github.com/IreneKnapp/oneko";
    license = with lib.licenses; [ publicDomain ];
    maintainers = with lib.maintainers; [
      xaverdh
      irenes
    ];
    platforms = lib.platforms.unix;
    mainProgram = "oneko";
  };
})
