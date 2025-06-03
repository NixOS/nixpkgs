{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ArchiSteamFarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "9920764dafb0a7a87c355d9c87aff285e41494be";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-w4pYFCdJiHocy41az4/tjWdBwAdI68RV/N8I0Onsofg=";
  };

  npmDepsHash = "sha256-V9u+n4CTB+BU0zeiB8vLpFkI2VJGArU6WL+PFfi624M=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official web interface for ASF";
    license = licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
