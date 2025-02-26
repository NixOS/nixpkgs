{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  electron_35,
  vulkan-loader,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? [ ],
  nix-update-script,
}:

let
  electron = electron_35;
in
buildNpmPackage (finalAttrs: {
  pname = "shogihome";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "sunfish-shogi";
    repo = "shogihome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vVKdaFKOx4xm4BK+AjVr4cEDOHpOjOe58k2wUAhB9XA=";
  };

  npmDepsHash = "sha256-OS5DR+24F98ICgQ6zL4VD231Rd5JB/gJKl+qNfnP3PE=";

  patches = [
    ./electron-builder-config.patch
  ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'npm run install:esbuild && ' "" \
      --replace-fail 'npm run install:electron && ' ""
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
    copyDesktopItems
  ];

  makeCacheWritable = true;

  dontNpmBuild = true;

  buildPhase =
    ''
      runHook preBuild

      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist
    ''
    # Electron builder complains about symlink in electron-dist
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      rm electron-dist/libvulkan.so.1
      cp '${lib.getLib vulkan-loader}/lib/libvulkan.so.1' electron-dist
    ''
    + ''
      npm run electron:pack

      ./node_modules/.bin/electron-builder \
          --dir \
          --config scripts/build.mjs \
          -c.electronDist=electron-dist \
          -c.electronVersion=${electron.version}

      runHook postBuild
    '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out/share/lib/shogihome"
      cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/shogihome"

      install -Dm444 'docs/icon.svg' "$out/share/icons/hicolor/scalable/apps/shogihome.svg"

      makeWrapper '${lib.getExe electron}' "$out/bin/shogihome" \
        --add-flags "$out/share/lib/shogihome/resources/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags ${lib.escapeShellArgs commandLineArgs} \
        --inherit-argv0
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      mv dist/mac*/ShogiHome.app "$out/Applications"
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "shogihome";
      exec = "shogihome %U";
      icon = "shogihome";
      desktopName = "ShogiHome";
      genericName = "Shogi Frontend";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      startupWMClass = "ShogiHome";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([\\d\\.]+)$"
      ];
    };
  };

  meta = {
    description = "Shogi frontend supporting USI engines";
    homepage = "https://sunfish-shogi.github.io/shogihome/";
    license = with lib.licenses; [
      mit
      asl20 # for icons
    ];
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "shogihome";
  };
})
