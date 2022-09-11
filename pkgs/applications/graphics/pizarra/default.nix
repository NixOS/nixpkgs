{ lib
, fetchFromGitLab
, rustPlatform
, cargo
, pkg-config
, binutils-unwrapped
, gtk3-x11
, atk
, glib
, librsvg
, gdk-pixbuf
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "pizarra";
  version = "1.7.3";

  src = fetchFromGitLab {
    owner = "categulario";
    repo = "pizarra-gtk";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-XP+P2w6s47JQV4spKeMKe/Ktxid7uokGYH4IEJ5VHSc=";
  };

  cargoSha256 = "sha256-JQZ/95tRlmsrb0EJaPlE8G0fMSeEgLnDi3pkLjcJz/o=";

  nativeBuildInputs = [ wrapGAppsHook pkg-config gdk-pixbuf ];

  buildInputs = [ gtk3-x11 atk glib librsvg ];

  meta = with lib; {
    description = "A simple blackboard written in GTK";
    longDescription = ''
      A simple endless blackboard.
      Contains various features, such as:
      - Pencil
      - Rectangle
      - Ellipse
      - Line
      - Text
      - Grids
    '';
    homepage = "https://pizarra.categulario.tk/en/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mglolenstine ];
  };
}
