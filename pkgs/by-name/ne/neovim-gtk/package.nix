{
  lib,
  rustPlatform,
  fetchFromGitHub,
  wrapGAppsHook4,
  pkg-config,
  gdk-pixbuf,
  gtk4,
  pango,
  vte-gtk4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neovim-gtk";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Lyude";
    repo = "neovim-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inva7pYwOw3bXvFeKZ4aKSQ65iCat5HxM+NME8jN4/I=";
  };

  cargoHash = "sha256-93cKoyLNSLDmm9PnJzn0x6VONPqiCA3wcLwYgdOLIg8=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    pango
    vte-gtk4
  ];

  patches = [ ./collect-box.patch ];

  postInstall = ''
    make PREFIX=$out install-resources
  '';

  meta = {
    description = "Gtk ui for neovim";
    homepage = "https://github.com/Lyude/neovim-gtk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      aleksana
    ];
    mainProgram = "nvim-gtk";
  };
})
