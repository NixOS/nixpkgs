{ stdenv
, lib
, fetchFromGitLab
, glib
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, libepoxy
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
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "megapixels";
    rev = version;
    hash = "sha256-zOtHxnXDzsLfaQPS0BhbuoUXglCbRULVJfk1txoS72Y=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libepoxy
    gtk4
    zbar
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = optionalString (tiffSupport || jpgSupport) ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.escapeShellArg runtimePath}
    )
  '';

  meta = with lib; {
    description = "GTK4 camera application that knows how to deal with the media request api";
    homepage = "https://gitlab.com/postmarketOS/megapixels";
    changelog = "https://gitlab.com/postmarketOS/megapixels/-/tags/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 dotlambda ];
    platforms = platforms.linux;
  };
}
