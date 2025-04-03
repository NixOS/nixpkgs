{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ArchiSteamFarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "c3113782bc4895099b1a07a0e811d1e5af871ddc";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-B2gn40LWVm75pwV5sQpv1gRsNof9tQUDClu7oLSz/VM=";
  };

  npmDepsHash = "sha256-Btf/S3ia8Uo/ChrKoYKRk9sKS+ZuQGtaAnaQeGDTIYI=";

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
