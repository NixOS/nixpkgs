{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  makeWrapper,
  autoPatchelfHook,
  nix-update-script,
  rustPlatform,
  wayland,
  libxkbcommon,
  libglvnd,
  vulkan-loader,
  dbus,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxrender,
  libxext,
  libxcb,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solidcraft";
  version = "0.29.0";
  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "tangency-labs";
    repo = "solidcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-krCAUoMqrfCr6fy8q2AJDXabJT+P+Og75JH2zrUABRU=";
  };

  cargoHash = "sha256-qZsoLrCHhPzIoYCQSsGaWPwmzCe7o+m6LCzg4Te4Ps0=";

  cargoBuildFlags = [
    "-p"
    "solidcraft"
    "-p"
    "solidcraft-cli"
  ];
  cargoInstallFlags = [
    "-p"
    "solidcraft"
    "-p"
    "solidcraft-cli"
  ];
  # `cargo xtask ci` is the test gate (it wants a wasm target and a GPU); the sandbox has
  # neither.
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    autoPatchelfHook
  ];

  buildInputs = [
    wayland
    libxkbcommon
    libglvnd
    vulkan-loader
    dbus
    stdenv.cc.cc.lib
    libx11
    libxcursor
    libxi
    libxrandr
    libxrender
    libxext
    libxcb
  ];

  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  postInstall = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 $src/assets/platforms/linux/io.tangencylabs.solidcraft.desktop \
        $out/share/applications/io.tangencylabs.solidcraft.desktop
      install -Dm644 $src/assets/platforms/linux/io.tangencylabs.solidcraft.mime.xml \
        $out/share/mime/packages/io.tangencylabs.solidcraft.xml
      for size in 16 24 32 48 64 128 256 512; do
        icon=$out/share/icons/hicolor/''${size}x''${size}/apps/io.tangencylabs.solidcraft.png
        mkdir -p "$(dirname "$icon")"
        cp $src/assets/icons/app/linux/exports/hicolor/''${size}x''${size}/apps/io.tangencylabs.solidcraft.png "$icon" >/dev/null
      done
    ''}
  '';

  meta = {
    description = "Rust-native parametric 3D CAD app";
    homepage = "https://github.com/tangency-labs/solidcraft";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "solidcraft";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.unix;
  };

})
