{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pyrra";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "pyrra-dev";
    repo = "pyrra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mm37W8IsUzMl8zRElYo6rtAoctBMs2av5uHqVuHH63w=";
  };

  vendorHash = "sha256-/IKzAsA3/2ygW7RocxFq4KmJj1z8ZSdx7wyxWeULet8=";

  ui = buildNpmPackage {
    inherit (finalAttrs) version;

    pname = "${finalAttrs.pname}-ui";
    src = "${finalAttrs.src}/ui";

    npmDepsHash = "sha256-jQez9MWqt+NK4Ot6/sA3ROlPe6Jq6Z63DXXzRP+ymxs=";

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
