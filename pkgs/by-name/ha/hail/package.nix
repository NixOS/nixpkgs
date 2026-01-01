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
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "periwinkle";
    repo = "hail";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-PpZfOC4M6XNcdAWd2E8ONruOq9yOTRutjKi86mmoxAo=";
  };

  cargoHash = "sha256-+zxoICy3lrS+7fZU0yD1C4uKRj/JtDvizKla1xmz+PY=";
=======
    hash = "sha256-LJodAS24x/dBNyrUxT9F0FHnu4s+Cb+CCtoe7nPM66w=";
  };

  cargoHash = "sha256-kEPnfRY2McSVNBuBC9VSKK5p8JIUeZh/LeFZQa1Hn5U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
