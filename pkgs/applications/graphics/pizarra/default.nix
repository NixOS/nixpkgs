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
  version = "1.7.4";

  src = fetchFromGitLab {
    owner = "categulario";
    repo = "pizarra-gtk";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-fWwAmzF3ppCvJZ0K4EDrmP8SVPVRayEQTtbhNscZIF0=";
  };

  cargoSha256 = "sha256-pxRJXUeFGdVj6iCFZ4Y8b9z5hw83g8YywpKztTZ0g+4=";

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
    homepage = "https://pizarra.categulario.xyz/en/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mglolenstine ];
  };
}
