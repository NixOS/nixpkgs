{ stdenv
, lib
, fetchgit
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
  version = "0.15.0";

  src = fetchgit {
    url = "https://git.sr.ht/~martijnbraam/megapixels";
    rev = version;
    sha256 = "1y8irwi8lbjs948j90gpic96dx5wjmwacd41hb3d9vzhkyni2dvb";
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
