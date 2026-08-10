{
  lib,
  buildNpmPackage,
  src,
  version,
}:

buildNpmPackage {
  inherit src version;
  pname = "photoprism-frontend";

  npmDepsHash = "sha256-HBzul2fyISwOqf8w92yt0friMnLhMmvKPm8yI2I3ngE=";

  npmWorkspace = "frontend";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r assets $out/

    runHook postInstall
  '';

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
  };
}
