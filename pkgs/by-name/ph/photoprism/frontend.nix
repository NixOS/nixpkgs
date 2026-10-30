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

  npmDepsHash = "sha256-iU81WODu0RCoCZg8Ds/R5j0Dxa9YFzBtKCvnow+bcyE=";

  npmWorkspace = "frontend";

  preBuild = ''
    (
      cd frontend
      npm rm sass-embedded
    )
  '';

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
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
  };
}
