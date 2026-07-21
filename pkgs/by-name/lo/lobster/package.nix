{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  callPackage,
  pkg-config,

  # Linux deps
  libGL,
  libxcursor,
  libxext,
  libxi,
  libx11,
  libxrandr,
  libxscrnsaver,
  libxtst,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lobster";
  version = "2026.4";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kqKOf0zrHyqRTs+57owHR5sORZgNIgGghtjUtSaFjZw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # TODO devendor sdl3 and remove these
    libGL
    libxcursor
    libx11
    libxext
    libxi
    libxrandr
    libxscrnsaver
    libxtst
  ];

  preConfigure = ''
    cd dev
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # The test suite expects the executable to be in any of a number of locations
  # that do not include the bin directory.
  preCheck = ''
    ln -s ../../bin/lobster lobster
  '';

  passthru.tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://strlen.com/lobster/";
    description = "Lobster programming language";
    mainProgram = "lobster";
    longDescription = ''
      Lobster is a programming language that tries to combine the advantages of
      very static typing and memory management with a very lightweight,
      friendly and terse syntax, by doing most of the heavy lifting for you.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
