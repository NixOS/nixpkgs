{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  archisteamfarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "8891c8b6d1c8caf82d9820a9b3722e36af3d066b";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-WQVHGTuGKJ4BNmq+vIboGcJTiJwt+bfHeO7IOlZhW5I=";
  };

  npmDepsHash = "sha256-YTM4/RGPt+VZL7cydGp4h38E4ej+TQeCZFVnk5aCPlw=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Official web interface for ASF";
    license = lib.licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (archisteamfarm.meta) maintainers platforms;
  };
}
