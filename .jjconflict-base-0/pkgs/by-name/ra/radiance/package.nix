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
  version = "5.4";

  src = fetchFromGitHub {
    owner = "LBNL-ETA";
    repo = "radiance";
    rev = "refs/tags/rad${lib.versions.major finalAttrs.version}R${lib.versions.minor finalAttrs.version}";
    hash = "sha256-21lVWqO8uJefnm/dyfrjQJYbGck0fIRr2j0A+7WlZbM=";
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
    license = lib.licenses.radiance;
    maintainers = with lib.maintainers; [ robwalt ];
    mainProgram = "rad";
  };
})
