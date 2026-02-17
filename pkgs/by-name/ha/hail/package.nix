{
  lib,
  rustPlatform,
  fetchFromCodeberg,
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
  version = "0.3.0";

  src = fetchFromCodeberg {
    owner = "periwinkle";
    repo = "hail";
    tag = finalAttrs.version;
    hash = "sha256-PpZfOC4M6XNcdAWd2E8ONruOq9yOTRutjKi86mmoxAo=";
  };

  cargoHash = "sha256-+zxoICy3lrS+7fZU0yD1C4uKRj/JtDvizKla1xmz+PY=";

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
