{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  archisteamfarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "ac9d5e40ff8865fb9542eababa9a03a774782a1d";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-NsETAXfH2dqKjU/vmkpRU3NrRdxwOg/JbAshXS3R9Uw=";
  };

  npmDepsHash = "sha256-7z2/2BM8p6TsMNNaMKcS7gzKUvHMZk8P3OIPBg7raJI=";

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
