{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "1d748b6ea01cc2ed7eebb32b4e8f990d8ff5c7d7";
    hash = "sha256-fb6fiZOnQeYzasL/NqCtTQTNOhdmIMG0mymaQ9zKQko=";
  };

  npmDepsHash = "sha256-xbGSmorPytbsjmcGOnGOYXWryMIwCPJ/ksMkSgSfJWY=";

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
