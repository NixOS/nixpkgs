{
  lib,
  stdenv,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  unzip,
  pkg-config,
  cmake,
  python3,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  openblas,
  alsa-lib,
  alsa-plugins,
  pipewire,
  libva,
  ffmpeg-headless,
  openssl,
  libxkbcommon,
  wayland,
  fontconfig,
  freetype,
  curl,
  wl-clipboard,
  wtype,
  makeWrapper,
  makeBinaryWrapper,
  autoAddDriverRunpath,
  symlinkJoin,
  util-linux,
  libx11,
  libxcb,
  libxcursor,
  libxrandr,
  libxi,
}:

let
  pname = "anomaly-hex";
  version = "3.4.0";

  alsaPlugins = symlinkJoin {
    name = "anomaly-hex-alsa-plugins";
    paths = [
      "${pipewire}/lib/alsa-lib"
      "${alsa-plugins}/lib/alsa-lib"
    ];
  };

  meta = {
    description = "Local-first voice dictation";
    homepage = "https://anoma.ly/hex/";
    changelog = "https://github.com/anomalyco/hex/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MarkusZoppelt
      kaynetik
    ];
    mainProgram = "hex";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };

  # Darwin repackages the notarized release zip: build.rs needs xcode-select
  # and Apple Swift frameworks that are unavailable in the sandbox
  darwin = stdenvNoCC.mkDerivation {
    inherit pname version;

    __structuredAttrs = true;

    src = fetchurl {
      url = "https://github.com/anomalyco/hex/releases/download/v${version}/hex-${version}-macos-arm64.zip";
      hash = "sha256-GrAkLcO7ARyIVokDy/Hp0wMQhnpG9RaDCYU9b4tMplA=";
    };

    nativeBuildInputs = [
      unzip
      makeBinaryWrapper
    ];

    sourceRoot = ".";

    dontBuild = true;

    # Rewriting Mach-O files would invalidate the code signature
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R Hex.app $out/Applications/Hex.app
      makeBinaryWrapper $out/Applications/Hex.app/Contents/MacOS/hex $out/bin/hex

      runHook postInstall
    '';

    passthru.updateScript = ./update.sh;

    meta = meta // {
      description = "Local-first voice dictation (prebuilt macOS app)";
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };

  linux = rustPlatform.buildRustPackage {
    inherit pname version;

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "anomalyco";
      repo = "hex";
      tag = "v${version}";
      hash = "sha256-SF0ZHokSzko63aoa3VvFtLhsQBg5XqZoqaG3TjMdqdw=";
    };

    cargoHash = "sha256-KoWOxFIrf0JlgPJoRkAH/zACMvzpkZtjRmu3UmHwAuo=";

    nativeBuildInputs = [
      pkg-config
      cmake
      python3
      shaderc
      makeWrapper
      autoAddDriverRunpath
    ];

    buildInputs = [
      vulkan-headers
      vulkan-loader
      spirv-headers
      openblas
      alsa-lib
      openssl
      libxkbcommon
      wayland
      fontconfig
      freetype
      libx11
      libxcb
      libxcursor
      libxrandr
      libxi
    ];

    # The OpenCode tests use curl; the adoption test runs the Linux installer, which needs flock
    nativeCheckInputs = [
      curl
      util-linux
    ];

    dontUseCmakeConfigure = true;

    env = {
      OPENSSL_NO_VENDOR = "1";
      BLA_VENDOR = "OpenBLAS";
    };

    # Desktop and installed-model tests are #[ignore]d upstream
    preCheck = ''
      export HOME="$TMPDIR/hex-test-home"
      mkdir -p "$HOME"
    '';

    postInstall = ''
      install -Dm644 packaging/anomaly.hex.desktop $out/share/applications/anomaly.hex.desktop
      substituteInPlace $out/share/applications/anomaly.hex.desktop \
        --replace-fail '@HEX_BIN@' "$out/bin/hex"
      mkdir -p $out/share/icons
      cp -R packaging/linux/icons/hicolor $out/share/icons/hicolor
    '';

    # Vulkan, OpenBLAS, ALSA, Wayland, PipeWire and VA-API are loaded at runtime
    postFixup = ''
      wrapProgram $out/bin/hex \
        --prefix PATH : ${
          lib.makeBinPath [
            curl
            wl-clipboard
            wtype
            ffmpeg-headless
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            vulkan-loader
            openblas
            alsa-lib
            wayland
            libxkbcommon
            fontconfig
            pipewire
            libva
          ]
        } \
        --set ALSA_PLUGIN_DIR ${alsaPlugins}
    '';

    passthru.updateScript = ./update.sh;

    inherit meta;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
