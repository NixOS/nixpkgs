{
  cmake,
  fetchFromGitHub,
  runCommand,
  lib,
  libGLU,
  stdenv,
  libX11,
  tcsh,
  tk,
}:
let
  csh = runCommand "csh" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe tcsh} $out/bin/csh
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "radiance";
  version = "6.0.1";

  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";

  src = fetchFromGitHub {
    owner = "LBNL-ETA";
    repo = "radiance";
    tag = "rad6R0P1a";
    hash = "sha256-W3Ss5R4qYVvtp7m2hcXv+0zH3C7//KAMATJHdQR+b8w=";
  };

  nativeBuildInputs = [
    cmake
    csh # for some custom scripting in the repo
    tk # for wish
  ];

  buildInputs = [
    libGLU
    libX11
  ];

  meta = {
    description = "Validated Lighting Simulation Tool";
    homepage = "https://github.com/LBNL-ETA/Radiance";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ robwalt ];
    mainProgram = "rad";
  };
})
