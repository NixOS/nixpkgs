{
  lib,
  buildNpmPackage,
  copyDesktopItems,
  electron_41,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  _experimental-update-script-combinators,
  writeShellApplication,
  nix,
  jq,
}:

let
  electron = electron_41;
  version = "2026.5.1";
in

buildNpmPackage (finalAttrs: {
  pname = "appium-inspector";
  inherit version;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium-inspector";
    tag = "v${version}";
    hash = "sha256-SJlTTVTZ/zGIK7Nf35cZ62tdhevXC95MsbiQJCLiVtk=";
  };

  npmDepsHash = "sha256-2rjgKS1mIrjOg+YXuMaqKyEQt0utLA4DGxOs0oI4BaQ=";
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    npm run build:electron
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/appium-inspector"
    cp -r release/*-unpacked/resources "$out/share/appium-inspector/"

    makeWrapper '${electron}/bin/electron' "$out/bin/appium-inspector" \
      --add-flags "$out/share/appium-inspector/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set NODE_ENV production

    install -m 444 -D 'app/common/renderer/assets/images/icon.png' \
      $out/share/icons/hicolor/256x256/apps/appium-inspector.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "appium-inspector";
      exec = "appium-inspector";
      desktopName = "Appium Inspector";
      comment = "A GUI inspector for mobile apps and more, powered by a (separately installed) Appium server";
      categories = [ "Development" ];
      icon = "appium-inspector";
    })
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (lib.getExe (writeShellApplication {
      name = "${finalAttrs.pname}-electron-updater";
      runtimeInputs = [
        nix
        jq
      ];
      runtimeEnv = {
        PNAME = finalAttrs.pname;
        PKG_FILE = toString ./package.nix;
      };
      text = ''
        new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)"
        new_electron_major="$(jq -r '.devDependencies.electron | split(".")[0] | tonumber' "$new_src/package.json")"
        sed -i -E "s/electron_[0-9]+/electron_$new_electron_major/g" "$PKG_FILE"
      '';
    }))
  ];

  meta = {
    description = "GUI inspector for the appium UI automation tool";
    homepage = "https://appium.github.io/appium-inspector";
    changelog = "https://github.com/appium/appium-inspector/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "appium-inspector";
    maintainers = with lib.maintainers; [ marie ];
    platforms = lib.platforms.linux;
  };
})
