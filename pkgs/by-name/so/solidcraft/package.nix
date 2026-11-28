{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  makeWrapper,
  autoPatchelfHook,
  nix-update-script,
  versionCheckHook,
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
  zenity,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solidcraft";
  version = "0.51.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tangency-labs";
    repo = "solidcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nZjv/4FoUeEh8wygN6rF+8m+BMkszxNiLWd/ONqAMvk=";
  };

  cargoHash = "sha256-DXLv9sUBsjWQ8VJooDws1kpV71PPokPdYODee48e35g=";

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
  # running tests requires a GPU
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
    zstd
  ];

  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 assets/platforms/linux/io.tangencylabs.solidcraft.desktop \
      $out/share/applications/io.tangencylabs.solidcraft.desktop
    install -Dm644 assets/platforms/linux/io.tangencylabs.solidcraft.workshop-links.desktop \
      $out/share/applications/io.tangencylabs.solidcraft.workshop-links.desktop
    install -Dm644 assets/platforms/linux/io.tangencylabs.solidcraft.mime.xml \
      $out/share/mime/packages/io.tangencylabs.solidcraft.xml
    for size in 16 24 32 48 64 128 256 512; do
      icon=$out/share/icons/hicolor/''${size}x''${size}/apps/io.tangencylabs.solidcraft.png
      mkdir -p "$(dirname "$icon")"
      cp assets/icons/app/linux/exports/hicolor/''${size}x''${size}/apps/io.tangencylabs.solidcraft.png "$icon" >/dev/null
    done
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/solidcraft \
      --suffix PATH : "${lib.makeBinPath [ zenity ]}"
  '';

  passthru.updateScript = nix-update-script { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Rust-native parametric 3D CAD app";
    homepage = "https://github.com/tangency-labs/solidcraft";
    changelog = "https://github.com/tangency-labs/solidcraft/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "solidcraft";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.unix;
  };

})
