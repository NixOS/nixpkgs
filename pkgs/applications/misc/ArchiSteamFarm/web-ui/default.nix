{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "b341e7f78f1f73fb3a11a3f3cfbfbed929242606";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-QrHBmLqvnVfHhBC+AF3YZUOx3ZEKA/FjtjXZW7ust8w=";
  };

  npmDepsHash = "sha256-MmNckugDMNlBs6dNg/JRE+Qf5P8LbwIesul+7Osd16Y=";

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
