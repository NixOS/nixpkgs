{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, autoPatchelfHook
, fontconfig
, xorg
, libglvnd
}:

buildDotnetModule rec {
  pname = "galaxy-buds-client";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "ThePBone";
    repo = "GalaxyBudsClient";
    rev = version;
    hash = "sha256-bnJ1xvqos+JP0KF8Z7mX8/8IozcaRCgaRL3cSO3V120=";
  };

  projectFile = [ "GalaxyBudsClient/GalaxyBudsClient.csproj" ];
  nugetDeps = ./deps.nix;
  dotnetFlags = [ "-p:Runtimeidentifier=linux-x64" ];

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
  ];

  runtimeDeps = [
    libglvnd
    xorg.libSM
    xorg.libICE
    xorg.libX11
  ];

  meta = with lib; {
    description = "Unofficial Galaxy Buds Manager for Windows and Linux";
    homepage = "https://github.com/ThePBone/GalaxyBudsClient";
    license = licenses.gpl3;
    maintainers = [ maintainers.icy-thought ];
    platforms = platforms.linux;
  };
}
