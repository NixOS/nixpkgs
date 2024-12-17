{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  makeBinaryWrapper,
  desktop-file-utils,
  electron,
}:
let
  version = "0.11.5";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "figma-linux";
  inherit version;

  src = fetchFromGitHub {
    owner = "Figma-Linux";
    repo = "figma-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pa0GgAmi9Os4EtZpbo0hSgr4s+WX95zLUrZR8a33TeI=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    makeBinaryWrapper
    desktop-file-utils
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-FqgcG52Nkj0wlwsHwIWTXNuIeAs7b+TPkHcg7m5D2og=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  buildPhase = ''
    runHook preBuild

    npm run build

    # The appDir is set to dist/ and node_modules/ has to be found inside it
    mkdir -p dist/node_modules
    ln -s node_modules/* -t dist/node_modules

    npm run builder -- \
      --dir \
      -c.electronVersion="${electron.version}" \
      -c.electronDist="${electron.dist}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/figma-linux
    cp -r build/installers/*-unpacked/{locales,resources{,.pak}} -t $out/share/figma-linux

    makeWrapper ${lib.getExe electron} $out/bin/figma-linux \
      --add-flags "$out/share/figma-linux/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -D resources/figma-linux.desktop -t $out/share/applications
    desktop-file-edit \
      --set-key=Exec --set-value="figma-linux %U" \
      $out/share/applications/figma-linux.desktop

    install -D resources/icons/scalable.svg $out/share/icons/hicolor/scalable/apps/figma-linux.png
    for f in 24 36 48 64 72 96 128 192 256 384 512; do
      install -D resources/icons/''${f}x''${f}.png $out/share/icons/hicolor/''${f}x''${f}/apps/figma-linux.png
    done

    runHook postInstall
  '';

  meta = {
    description = "Unofficial Electron-based Figma desktop app for Linux";
    homepage = "https://github.com/Figma-Linux/figma-linux";
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ercao
      kashw2
    ];
    mainProgram = "figma-linux";
  };
})
