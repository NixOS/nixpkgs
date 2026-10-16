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
  libgcc,
}:
let
  runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux (
    [
      wayland
      libxkbcommon
      libglvnd
      vulkan-loader
      dbus
      libgcc
    ]
    ++ [
      libx11
      libxcursor
      libxi
      libxrandr
      libxrender
      libxext
      libxcb
    ]
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solidcraft";
  version = "0.14.0";
  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "bherbruck";
    repo = "solidcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WKQ0YgGnAm1lsEYtTbRhz9L0WpkEO7jqmIktsIZp/30=";
  };

  cargoHash = "sha256-bh6KHn4OzqFPhqbLNaYSPrG5ZOlvX4NfLADaPO/7N3A=";

  # The CLI draws the same packaging icons as the other Linux distributions.
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
    autoPatchelfHook
  ];
  buildInputs = runtimeLibs;

  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  postInstall = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 $src/assets/platforms/linux/ai.storyteller.solidcraft.desktop \
        $out/share/applications/ai.storyteller.solidcraft.desktop
      install -Dm644 $src/assets/platforms/linux/ai.storyteller.solidcraft.mime.xml \
        $out/share/mime/packages/ai.storyteller.solidcraft.xml
      for size in 16 24 32 48 64 128 256 512; do
        icon=$out/share/icons/hicolor/''${size}x''${size}/apps/ai.storyteller.solidcraft.png
        mkdir -p "$(dirname "$icon")"
        cp $src/assets/icons/app/linux/exports/hicolor/''${size}x''${size}/apps/ai.storyteller.solidcraft.png "$icon" >/dev/null
      done
    ''}
  '';

  meta = {
    description = "Rust-native parametric 3D CAD app";
    homepage = "https://github.com/bherbruck/solidcraft";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "solidcraft";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.unix;
  };

})
