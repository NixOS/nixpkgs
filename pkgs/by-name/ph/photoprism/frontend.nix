{
  lib,
  buildNpmPackage,
  src,
  version,
  nix-update-script,
}:

buildNpmPackage {
  inherit src version;
  pname = "photoprism-frontend";

  npmDepsHash = "sha256-8vi5ETVO2t7evJRPge2Ck7iMNAOIbArNHZ8R8Nrx0o8=";

  npmWorkspace = "frontend";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r assets $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
  };
}
