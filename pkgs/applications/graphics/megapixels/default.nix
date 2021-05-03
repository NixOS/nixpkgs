{ stdenv
, lib
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gtk3
, gnome3
, zbar
, tiffSupport ? true
, libraw
, jpgSupport ? true
, graphicsmagick
, exiftool
}:

assert jpgSupport -> tiffSupport;

let
  inherit (lib) makeBinPath optional optionals optionalString;
  runtimePath = makeBinPath (
    optional tiffSupport libraw
    ++ optionals jpgSupport [ graphicsmagick exiftool ]
  );
in
stdenv.mkDerivation rec {
  pname = "megapixels";
  version = "0.16.0";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "megapixels";
    rev = version;
    sha256 = "0z7sx76x18yqf7carq6mg9lib0zbz0yrd1dsg9qd6hbf5niqis37";
  };

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 gnome3.adwaita-icon-theme zbar ]
  ++ optional tiffSupport libraw
  ++ optional jpgSupport graphicsmagick;

  preFixup = optionalString (tiffSupport || jpgSupport) ''
    gappsWrapperArgs+=(
      --prefix PATH : ${runtimePath}
    )
  '';

  meta = with lib; {
    description = "GTK3 camera application using raw v4l2 and media-requests";
    homepage = "https://sr.ht/~martijnbraam/Megapixels";
    changelog = "https://git.sr.ht/~martijnbraam/megapixels/refs/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
