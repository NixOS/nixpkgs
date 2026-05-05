{
  lib,
  rustPlatform,
  nodejs,
  npmHooks,
  fetchFromGitHub,
  fetchNpmDeps,
  makeDesktopItem,
  copyDesktopItems,
  controlPort ? 30912,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "framework-control";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "ozturkkl";
    repo = "framework-control";
    tag = finalAttrs.version;
    hash = "sha256-xXysqKwHYD5jfbiYddeckj2BE349CYeD20to1BF8jFs=";
  };

  cargoHash = "sha256-fAx3scGTWIkkqqTmzpxp4Z4LxKxVjED5x9qikJpCGf4=";

  cargoRoot = "service";
  buildAndTestSubdir = "service";

  npmRoot = "web";

  npmDeps = fetchNpmDeps {
    name = "framework-control-npm-deps";
    src = "${finalAttrs.src}/web";
    hash = "sha256-ZTvYT5x+7X3+PfBxaR6YzRlTKH1DBvwlxC281Srq2Og=";
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

  FRAMEWORK_CONTROL_PORT = controlPort;

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

  meta = {
    description = "Lightweight control surface for Framework laptops";
    homepage = "https://github.com/ozturkkl/framework-control";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ozturkkl ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "framework-control";
  };
})
