{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcb,
  libxi,
  libxkbcommon,
  vulkan-loader,
  wayland,
  SDL2,
  SDL2_image,
  SDL2_gfx,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hail";
  version = "0.5.0";

  src = fetchFromCodeberg {
    owner = "periwinkle";
    repo = "hail";
    tag = finalAttrs.version;
    hash = "sha256-yfPw98Bj108BNhR7ObrlAKsh2v+mViojuEuDLlyBDUE=";
  };

  cargoHash = "sha256-4nHOyQ2hEhwf4iSDuHjRawYDfv3b0a508IFcq6JUN8M=";

  # Configurator and split editor, which hail starts from its keybinds
  cargoBuildFlags = [
    "--package=hail"
    "--package=hail_config"
    "--package=hail_editor"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    wayland
    SDL2
    SDL2_image
    SDL2_gfx
  ];

  # Windowing and graphics libraries the configurator and split editor load at runtime
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        libx11
        libxcb
        libxi
        libxkbcommon
        vulkan-loader
        wayland
      ]
    } $out/bin/hail_config $out/bin/hail_editor
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal speedrun timer";
    homepage = "https://codeberg.org/periwinkle/hail";
    changelog = "https://codeberg.org/periwinkle/hail/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "hail";
    platforms = lib.platforms.linux;
  };
})
