{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pyrra";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "pyrra-dev";
    repo = "pyrra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3eEnwS3nnDuIYfZCDUrWFeNmAHEGWtpxtSVoI+XIMVM=";
  };

  vendorHash = "sha256-E2/OrAC2Wkv7OYPjs9ROE1RL4UUXYTByJZRY1qZB3gE=";

  ui = buildNpmPackage {
    inherit (finalAttrs) version;

    pname = "${finalAttrs.pname}-ui";
    src = "${finalAttrs.src}/ui";

    npmDepsHash = "sha256-1KSkYUIJy6uci+Cy2q4dXO2PGpnwKcXQmWaWmpjPneA=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/pyrra
      mv build $out/share/pyrra/ui
      runHook postInstall
    '';
  };

  preBuild = ''
    mkdir -p ui/build
    cp -r ${finalAttrs.ui}/share/pyrra/ui/* ui/build
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "ui"
    ];
  };

  meta = {
    mainProgram = "pyrra";
    description = "Making SLOs with Prometheus manageable, accessible, and easy to use for everyone!";
    homepage = "https://github.com/pyrra-dev/pyrra";
    changelog = "https://github.com/pyrra-dev/pyrra/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      metalmatze
      numbleroot
    ];
  };
})
