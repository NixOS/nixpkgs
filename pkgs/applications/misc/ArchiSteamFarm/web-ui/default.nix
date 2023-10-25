{ lib, fetchFromGitHub, buildNpmPackage, nodePackages, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "0dc9b31a571fe840ac1661b9e9777f253304529d";
    hash = "sha256-gY+4H6roqqoRFTwyNboXKg8LM7BfxQYYij/eilohFNY=";
  };

  npmDepsHash = "sha256-3sRjlFuFyG8j8CPKG8Gj5QhE4YD9DJ5qaTJlNJT2Oao=";

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
