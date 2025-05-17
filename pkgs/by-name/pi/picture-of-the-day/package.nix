{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  glib,
  gobject-introspection,
  blueprint-compiler,
  libadwaita,
  gtk4,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "picture-of-the-day";
  version = "1.4.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "swsnr";
    repo = "picture-of-the-day";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RrpqLq3FThnGsFbz93tHpFP/HVUpOO8bwFF2bY/OyJ4=";
  };

  cargoHash = "sha256-g1kRcEXEtvCvlm8Lrv9os0dWvMD9RGXb5SPXJL3mvXg=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
    gobject-introspection
    blueprint-compiler
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Your daily GNOME wallpaper";
    homepage = "https://codeberg.org/swsnr/picture-of-the-day";
    changelog = "https://codeberg.org/swsnr/picture-of-the-day/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "picture-of-the-day";
  };
})
