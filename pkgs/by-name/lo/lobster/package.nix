{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  callPackage,

  # Linux deps
  libGL,
  libxext,
  libx11,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lobster";
  version = "2026.1";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kN4KYd0wTHqF3J4wFGHLmHifkxsb6J+Ex7gGRGnFiGk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libx11
    libxext
  ];

  preConfigure = ''
    cd dev
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
