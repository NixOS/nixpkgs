{ lib, fetchFromGitHub, buildNpmPackage, nodePackages, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "578e8eacf9eb0367d864ed741017dce23415c1be";
    hash = "sha256-It76gyrTPiZFEj9aSFKwAsj2jhV3zacJS8CNl4sr7OU=";
  };

  npmDepsHash = "sha256-7404OPGhF7bgdvtyfLM/7zRXGUWPr2RLUCzeaHcCj0A=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "The official web interface for ASF";
    license = licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
