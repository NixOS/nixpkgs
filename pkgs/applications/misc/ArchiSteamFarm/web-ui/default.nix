{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "f84a296f0ab029e56baba3cca45e5cf21129fd76";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-NISUhxClFAzLQp4o9AzMzasPV9+aBAyDd1tuNT7HJw4=";
  };

  npmDepsHash = "sha256-kI7kgSw0xs8Hsa/5lhLteDo8TgwyxIxKE1QK92D1Qio=";

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
