{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "photocraft";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "photocraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MpvMiONXNd3w/NUQI3xZ8SKJFor42w0sxHHEFHnXgGw=";
  };

  cargoHash = "sha256-GytJ3eaPf18GDgAPxbKCZ6ibrxzLcnht4KLC/0UxrbM=";

  cargoBuildFlags = [
    "--package"
    "photocraft"
    "--package"
    "photocraft-cli"
  ];

  cargoTestFlags = [
    "--package"
    "photocraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 $sourceRoot/packaging/linux/ai.storyteller.photocraft.desktop \
      $out/share/applications/ai.storyteller.photocraft.desktop
    substituteInPlace $out/share/applications/ai.storyteller.photocraft.desktop \
      --replace-fail 'Exec=photocraft %F' "Exec=$out/bin/photocraft %F"

    for size in 16 24 32 48 64 128 256 512; do
      install -Dm444 \
        $sourceRoot/assets/app-icon/hicolor/''${size}x''${size}/apps/ai.storyteller.photocraft.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/ai.storyteller.photocraft.png
    done
    install -Dm444 \
      $sourceRoot/assets/app-icon/hicolor/scalable/apps/ai.storyteller.photocraft.svg \
      $out/share/icons/hicolor/scalable/apps/ai.storyteller.photocraft.svg

    wrapProgram $out/bin/photocraft \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, native image editor with layered PSD/PSB support";
    homepage = "https://github.com/storytold/photocraft";
    changelog = "https://github.com/storytold/photocraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "photocraft";
    platforms = lib.platforms.linux;
  };
})
