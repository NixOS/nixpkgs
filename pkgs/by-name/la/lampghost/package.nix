{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  wails,
  webkitgtk_4_1,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: rec {
  pname = "lampghost";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Catizard";
    repo = "lampghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PM6+QG9pBBDqaK60i4IXZ56UgXJ+DoOZqKJ/+HjdMjo=";
  };

  vendorHash = "sha256-WU9sjoV1cfzt+Ol0pWwWeqwxGXnGsuz0BSI2GcCmh9Q=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-YYF6RfA3uE65QdwuJMV+NSvGYtmZRxwrVbQtijNyHRE=";
    };
    npmRoot = "frontend";
  };

  nativeBuildInputs = [
    wails
    pkg-config
    autoPatchelfHook
    nodejs
    npmHooks.npmConfigHook
    copyDesktopItems
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ webkitgtk_4_1 ];

  buildPhase = ''
    runHook preBuild

    wails build -m -trimpath -devtools -tags webkit2_41 -o ${pname}

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "${pname}";
      exec = "${pname}";
      desktopName = "LampGhost";
      comment = "Offline & Cross-platform beatoraja lamp viewer and more";
      categories = [ "Game" ];
      startupNotify = true;
      keywords = [ "beatoraja" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 build/bin/${pname} $out/bin/${pname}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Offline & Cross-platform beatoraja lamp viewer and more";
    homepage = "https://github.com/Catizard/lampghost";
    changelog = "https://github.com/Catizard/lampghost/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "${pname}";
    maintainers = with lib.maintainers; [ MiyakoMeow ];
    platforms = lib.platforms.linux;
  };
})
