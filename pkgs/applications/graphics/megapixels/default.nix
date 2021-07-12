{ stdenv
, lib
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wrapGAppsHook
, epoxy
, gtk4
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
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "megapixels";
    rev = version;
    sha256 = "0y56c6vchlzidfmp3a3bdc228vbhy7zaxvmhkyxchfb752yzr0n3";
  };

  nativeBuildInputs = [ meson ninja pkg-config wrapGAppsHook ];

  buildInputs = [
    epoxy
    gtk4
    zbar
  ];

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
    maintainers = with maintainers; [ OPNA2608 dotlambda ];
    platforms = platforms.linux;
  };
}
