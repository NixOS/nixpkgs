{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  wayland,
  SDL2,
  SDL2_image,
  SDL2_gfx,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hail";
  version = "0.2.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "periwinkle";
    repo = "hail";
    tag = finalAttrs.version;
    hash = "sha256-LJodAS24x/dBNyrUxT9F0FHnu4s+Cb+CCtoe7nPM66w=";
  };

  cargoHash = "sha256-kEPnfRY2McSVNBuBC9VSKK5p8JIUeZh/LeFZQa1Hn5U=";

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
