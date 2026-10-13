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

  npmDepsHash = "sha256-guU5vVhYo5Cv+KpNyAVNmJ1kcjSkPkAz+Be4hGe4mpM=";

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
