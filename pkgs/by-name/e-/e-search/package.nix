{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  gitMinimal,
  gobject-introspection,
  makeWrapper,
  nodejs_20,
  pnpm_10,
  electron,
  atk,
  atkmm,
  cairo,
  cairomm,
  gdk-pixbuf,
  glib,
  glibmm,
  gtk3,
  gtkmm3,
  harfbuzz,
  libsForQt5,
  pango,
  pangomm,
  xorg,
  zlib,
  nix-update-script,
  commandLineArgs ? "",
}:

let
  eSearch-OCR-ch = fetchzip {
    url = "https://github.com/xushengfeng/eSearch-OCR/releases/download/4.0.0/ch.zip";
    hash = "sha256-0NCXuy8k9/AdpK4ie49S8032u37gNhX6Jc6bOGufrV4=";
    stripRoot = false;
  };
  eSearch-OCR-doc_cls = fetchurl {
    url = "https://github.com/xushengfeng/eSearch-OCR/releases/download/8.1.0/doc_cls.onnx";
    hash = "sha256-9VFoIq+SYnEeGX/yJKip2IT4BGpjIbdi40+MvwgsRe8=";
  };
  eSearch-seg = fetchurl {
    url = "https://github.com/xushengfeng/eSearch-seg/releases/download/1.0.0/seg.onnx";
    hash = "sha256-IJSPX4Kg7wIPjdXVmpGbeSk2y98OS+tJrIth9W+J/Q8=";
  };
  eSearch-migan_pipeline_v2 = fetchurl {
    url = "https://github.com/xushengfeng/eSearch/releases/download/13.1.6/migan_pipeline_v2.onnx";
    hash = "sha256-bx81MKGiMksZdSAYznVgiLB5c82o19iQA0rOXIpIxAs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "e-search";
  version = "15.2.1";

  src = fetchFromGitHub {
    owner = "xushengfeng";
    repo = "eSearch";
    tag = finalAttrs.version;
    hash = "sha256-K4GFLUeq/IbJC3FZBgvKnZq7JrXkqe6eVGsUxxlpWF0=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    prePnpmInstall = ''
      export PATH=$PATH:${gitMinimal}/bin
    '';
    hash = "sha256-wPwsFY7wvbE1LW5PMwMZKejELtqmdsYO2RVrEuOzdcg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gobject-introspection
    pnpm_10.configHook
    makeWrapper
    nodejs_20
  ];

  buildInputs = [
    atk
    atkmm
    cairo
    cairomm
    gdk-pixbuf
    glib
    glibmm
    gtk3
    gtkmm3
    harfbuzz
    (lib.getLib stdenv.cc.cc)
    libsForQt5.kauth
    libsForQt5.kcodecs
    libsForQt5.kcompletion
    libsForQt5.kconfigwidgets
    libsForQt5.kcoreaddons
    libsForQt5.kitemviews
    libsForQt5.kjobwidgets
    libsForQt5.kservice
    libsForQt5.kwidgetsaddons
    libsForQt5.kio
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtnetworkauth
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtxmlpatterns
    pango
    pangomm
    xorg.libX11
    xorg.libXrandr
    xorg.libXt
    xorg.libXtst
    xorg.libxcb
    zlib
  ];

  env = {
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/libexec/electron";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  preBuild = ''
    mkdir -p assets/onnx/ppocr assets/onnx/seg assets/onnx/inpaint
    cp --recursive --no-preserve=mode ${eSearch-OCR-ch}/* assets/onnx/ppocr
    cp --no-preserve=mode ${eSearch-OCR-doc_cls} assets/onnx/ppocr/doc_cls.onnx
    cp --no-preserve=mode ${eSearch-seg} assets/onnx/seg/seg.onnx
    cp --no-preserve=mode ${eSearch-migan_pipeline_v2} assets/onnx/inpaint/migan_pipeline_v2.onnx
  '';

  buildPhase = ''
    runHook preBuild

    npm run build
    npm exec electron-builder -- \
      --linux \
      --dir \
      -p never \
      --config electron-builder.config.js \
      --config.electronDist=${electron.dist} \
      --config.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/eSearch
    ${
      if stdenv.hostPlatform.isAarch64 then
        "cp -r build/linux-arm64-unpacked/{resources,LICENSE*} $out/share/eSearch"
      else
        "cp -r build/linux-unpacked/{resources,LICENSE*} $out/share/eSearch"
    }
    makeWrapper ${lib.getExe electron} $out/bin/e-search \
      --inherit-argv0 \
      --add-flags $out/share/eSearch/resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
    for icon_size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512 1024x1024; do
      install -Dm0644 assets/logo/$icon_size.png $out/share/icons/hicolor/$icon_size/apps/e-search.png
    done
    install -Dm0644 assets/e-search.desktop $out/share/applications/e-search.desktop

    runHook postInstall
  '';

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screenshot OCR search translate search for picture paste the picture on the screen screen recorder";
    homepage = "https://github.com/xushengfeng/eSearch";
    changelog = "https://github.com/xushengfeng/eSearch/releases/tag/${finalAttrs.version}";
    mainProgram = "e-search";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ qzylinra ];
  };
})
