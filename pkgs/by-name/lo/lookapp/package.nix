{
  lib,
  stdenv,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  unzip,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  libxcb,
  libxau,
  libxdmcp,
  wayland,
  vulkan-loader,
  libglvnd,
  alsa-lib,
  fontconfig,
  freetype,
  xdg-utils,
  curl,
  procps,
  glib,
}:

let
  version = "0.7.3";

  meta = {
    description = "Keyboard-first, local-first desktop launcher";
    homepage = "https://github.com/kunkka19xx/look";
    changelog = "https://github.com/kunkka19xx/look/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "lookapp";
    maintainers = with lib.maintainers; [
      Teamofeyy
      kunkka19xx
    ];
  };

  # Opened at runtime, never linked: wgpu loads the Vulkan loader and GL,
  # gpui's Wayland client loads libwayland. An rpath keeps them out of the
  # environment of every app Look launches.
  runtimeLibs = [
    vulkan-loader
    libglvnd
    wayland
  ];

  linux = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "lookapp";
    inherit version;

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "kunkka19xx";
      repo = "look";
      tag = "v${finalAttrs.version}";
      hash = "sha256-24smjFpWVKpqDGjqVVfgssazuThbefxC229zkbexwdI=";
    };

    # The workspace lockfile covers both shells; only the gpui one is built.
    cargoRoot = "apps/linows";
    buildAndTestSubdir = "apps/linows/gpui";

    cargoHash = "sha256-chw33HqPT0IfVsmUIYsUpDC2uk3kN7P+xD19DYkVbYM=";

    nativeBuildInputs = [
      pkg-config
      makeBinaryWrapper
    ];

    buildInputs = [
      libxkbcommon
      libxcb
      libxau
      libxdmcp
      alsa-lib
      fontconfig
      freetype
    ];

    postInstall = ''
      install -Dm644 $src/apps/linows/packaging/lookapp.desktop \
        -t $out/share/applications
      for size in 32 64 128; do
        install -Dm644 $src/apps/linows/icons/''${size}x''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/lookapp.png
      done
      install -Dm644 $src/apps/linows/icons/128x128@2x.png \
        $out/share/icons/hicolor/256x256/apps/lookapp.png
    '';

    postFixup = ''
      patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/lookapp
      wrapProgram $out/bin/lookapp \
        --prefix PATH : ${
          lib.makeBinPath [
            xdg-utils
            fontconfig
            curl
            procps
            # gdbus backs the Wayland hotkey registration.
            glib
          ]
        }
    '';

    passthru.updateScript = ./update.sh;

    meta = meta // {
      platforms = lib.platforms.linux;
    };
  });

  # apps/macos is an Xcode target, so there is no source build to offer. The
  # release zip is also the only build carrying the Developer ID signature and
  # the notarization ticket, which macOS keys the Accessibility grant to.
  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "lookapp";
    inherit version;

    __structuredAttrs = true;

    src = fetchurl {
      url = "https://github.com/kunkka19xx/look/releases/download/v${finalAttrs.version}/Look-${finalAttrs.version}-macOS.zip";
      hash = "sha256-TttGb3rKxHzYGrPJ/Z2BcXnxS7JOHC1S8TqULpwIAFw=";
    };

    nativeBuildInputs = [ unzip ];

    # The zip holds Look.app at the top level and nothing beside it.
    sourceRoot = ".";

    # Signed and notarized: rewriting anything inside the bundle breaks the seal.
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R Look.app $out/Applications/
      # Started through the link, the app hands off to the bundle it lives in.
      ln -s $out/Applications/Look.app/Contents/MacOS/Look $out/bin/lookapp

      runHook postInstall
    '';

    passthru.updateScript = ./update.sh;

    meta = meta // {
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
