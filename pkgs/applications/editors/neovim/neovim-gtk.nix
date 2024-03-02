{ lib
, rustPlatform
, fetchFromGitHub
, wrapGAppsHook4
, pkg-config
, gdk-pixbuf
, gtk4
, pango
, vte-gtk4
}:

rustPlatform.buildRustPackage rec {
  pname = "neovim-gtk";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Lyude";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-inva7pYwOw3bXvFeKZ4aKSQ65iCat5HxM+NME8jN4/I=";
  };

  cargoHash = "sha256-9eZwCOP4xQtFOieqVRBAdXZrXmzdnae6PexGJ/eCyYc=";

  nativeBuildInputs = [ wrapGAppsHook4 pkg-config ];

  buildInputs = [ gdk-pixbuf gtk4 pango vte-gtk4 ];

  postInstall = ''
    make PREFIX=$out install-resources
  '';

  meta = with lib; {
    description = "Gtk ui for neovim";
    homepage = "https://github.com/Lyude/neovim-gtk";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "nvim-gtk";
  };
}
