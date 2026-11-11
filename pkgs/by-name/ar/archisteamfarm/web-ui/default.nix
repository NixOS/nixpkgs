{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  archisteamfarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "66cde9c899248f2c2f2b4e8d402646a8642cb345";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-rkfWL41Ib4ADfYYWQMsNSDYpHUwLTPdixDIdEWqvs0Q=";
  };

  npmDepsHash = "sha256-y9lOp1TsMv9eewaMzP2SZOKGJsbazzoJWVbV/eS3P4c=";

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
