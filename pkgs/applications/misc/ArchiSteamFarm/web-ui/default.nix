{ lib, fetchFromGitHub, buildNpmPackage, nodePackages, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "0b812a7ab0d2f01a675d27f80008ad7b6972b4aa";
    hash = "sha256-ut0x/qT3DyDASW4QbNT+BF6eXHCIbTol5E+3+tirFDA=";
  };

  npmDepsHash = "sha256-HpBEoAIGejpHJnUciz4iWILcXdgpw7X1xFuXmx9Z9dw=";

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
