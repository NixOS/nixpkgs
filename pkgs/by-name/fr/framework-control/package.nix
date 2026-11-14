{
  lib,
  rustPlatform,
  nodejs,
  npmHooks,
  fetchFromGitHub,
  fetchNpmDeps,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  controlPort ? 30912,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-control";
  version = "0.5.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ozturkkl";
    repo = "framework-control";
    tag = finalAttrs.version;
    hash = "sha256-GU7//aEjplqP+MoYtj3YB3YBB1iosioxPh1aiIUUDEc=";
  };

  cargoHash = "sha256-QZPYGhJ+8YkyCuqtDZbVjSXPrtIVHNVEwRhGk9DUzGM=";

  cargoRoot = "service";
  buildAndTestSubdir = "service";

  npmRoot = "web";

  npmDeps = fetchNpmDeps {
    name = "framework-control-npm-deps";
    src = "${finalAttrs.src}/web";
    hash = "sha256-2zyWsRLYzAanuAqHvvxoGEqPn6p1XPv+LUrHGVDGIrY=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "framework-control";
      desktopName = "Framework Control";
      comment = "Lightweight control surface for Framework laptops";
      exec = "xdg-open http://127.0.0.1:${toString controlPort}";
      icon = "framework-control";
      terminal = false;
      categories = [
        "Utility"
        "System"
      ];
      startupNotify = true;
    })
  ];

  env.FRAMEWORK_CONTROL_PORT = controlPort;

  preBuild = ''
    pushd web
    npm run build
    popd
  '';

  buildFeatures = [ "embed-ui" ];

  postInstall = ''
    mv $out/bin/framework-control-service $out/bin/framework-control

    install -Dm644 web/public/assets/logo.png \
      $out/share/icons/hicolor/256x256/apps/framework-control.png
  '';

  # Upstream pre-releases use plain version tags; the releases API exposes the prerelease flag.
  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Lightweight control surface for Framework laptops";
    homepage = "https://github.com/ozturkkl/framework-control";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ozturkkl ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "framework-control";
  };
})
