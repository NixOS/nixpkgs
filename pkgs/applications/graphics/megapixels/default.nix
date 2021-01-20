{ stdenv
, lib
, fetchgit
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gtk3
, gnome3
, tiffSupport ? true
, libraw
, jpgSupport ? true
, imagemagick
, exiftool
}:

assert jpgSupport -> tiffSupport;

let
  inherit (lib) makeBinPath optional optionals optionalString;
  runtimePath = makeBinPath (
    optional tiffSupport libraw
    ++ optionals jpgSupport [ imagemagick exiftool ]
  );
in
stdenv.mkDerivation rec {
  pname = "megapixels";
  version = "0.14.0";

  src = fetchgit {
    url = "https://git.sr.ht/~martijnbraam/megapixels";
    rev = version;
    sha256 = "136rv9sx0kgfkpqn5s90j7j4qhb8h04p14g5qhqshb89kmmsmxiw";
  };

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 gnome3.adwaita-icon-theme ]
  ++ optional tiffSupport libraw
  ++ optional jpgSupport imagemagick;

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
