{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
<<<<<<< HEAD
=======
  gtk4,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  gtk4-layer-shell,
  hyprland,
  gcc,
  pixman,
<<<<<<< HEAD
  libadwaita,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprshell";
<<<<<<< HEAD
  version = "4.8.3";
=======
  version = "4.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-MO3v5YTVRGp0k0WNZSmal2e9Un9EBCsKwl3NL5PyJUI=";
  };

  cargoHash = "sha256-4XlyVuePqB9hBNNOjnipA2FVJJwP/7dJR594o8u1rNQ=";
=======
    hash = "sha256-6WC7vcPdtKR4iw5VHF88i/NQ+EBfvGxex8AvJONnG5w=";
  };

  cargoHash = "sha256-g23W5cgGxWNyJ4uew2x12vgF5Bvaid1+phV2fxyHbas=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
<<<<<<< HEAD
    libadwaita
=======
    gtk4
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    gtk4-layer-shell
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : '${lib.makeBinPath [ gcc ]}'
      --prefix CPATH : '${
        lib.makeIncludePath (
          hyprland.buildInputs
          ++ [
            hyprland
            pixman
          ]
        )
      }'
    )
  '';

  meta = {
    description = "Modern GTK4-based window switcher and application launcher for Hyprland";
    mainProgram = "hyprshell";
    homepage = "https://github.com/H3rmt/hyprshell";
    license = lib.licenses.mit;
    platforms = hyprland.meta.platforms;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
