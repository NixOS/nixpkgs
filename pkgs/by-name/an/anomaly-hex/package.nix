{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
  autoAddDriverRunpath,
  symlinkJoin,
  libx11,
  libxcb,
  libxcursor,
  libxrandr,
  libxi,
  nix-update-script,
}:

let
  alsaPlugins = symlinkJoin {
    name = "anomaly-hex-alsa-plugins";
    paths = [
      "${pipewire}/lib/alsa-lib"
      "${alsa-plugins}/lib/alsa-lib"
    ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anomaly-hex";
  version = "3.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "hex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LhtYNTzZ2au14c5bG7v+Ps2KUC9r6mBFtp9mg7FmOOQ=";
  };

  cargoHash = "sha256-cXGE2nx/imST9BI9f3E26/NPbpu+FX+7q/FdcWMwNh0=";

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

  # The OpenCode integration tests make HTTP requests through curl
  nativeCheckInputs = [ curl ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first voice dictation";
    homepage = "https://anoma.ly/hex/";
    changelog = "https://github.com/anomalyco/hex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MarkusZoppelt ];
    mainProgram = "hex";
    platforms = [ "x86_64-linux" ];
  };
})
