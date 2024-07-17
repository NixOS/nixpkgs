{
  buildDotnetModule,
  fetchFromGitHub,
  fontconfig,
  lib,
  openal,
  xorg,
}:

buildDotnetModule rec {
  pname = "knossosnet";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "KnossosNET";
    repo = "Knossos.NET";
    rev = "v${version}";
    hash = "sha256-4GVbwBykagSMGF3TxyZeoRb7Km+yLEMFOO8fCkH3U5A=";
  };

  patches = [ ./targetframework.patch ];

  nugetDeps = ./deps.nix;
  executables = [ "Knossos.NET" ];

  runtimeDeps = [
    fontconfig
    openal
    xorg.libX11
    xorg.libICE
    xorg.libSM
  ];

  meta = with lib; {
    homepage = "https://github.com/KnossosNET/Knossos.NET";
    description = "Multi-platform launcher for Freespace 2 Open";
    license = licenses.gpl3Only;
    mainProgram = "Knossos.NET";
    maintainers = with maintainers; [ cdombroski ];
  };
}
