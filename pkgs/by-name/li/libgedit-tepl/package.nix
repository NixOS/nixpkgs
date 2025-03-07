{ stdenv
, lib
, fetchFromGitHub
, meson
, mesonEmulatorHook
, ninja
, gobject-introspection
, gtk3
, icu
, libhandy
, libgedit-amtk
, libgedit-gfls
, libgedit-gtksourceview
, pkg-config
, gtk-doc
, docbook-xsl-nons
}:

stdenv.mkDerivation rec {
  pname = "libgedit-tepl";
  version = "6.10.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "gedit-technology";
    repo = "libgedit-tepl";
    rev = version;
    hash = "sha256-lGmOaDNu+iqwpeaP0AL28exoTqx1j03Z8gdhTBgk1i8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    pkg-config
    gtk-doc
    docbook-xsl-nons
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    icu
    libhandy
  ];

  propagatedBuildInputs = [
    gtk3
    libgedit-amtk
    libgedit-gfls
    libgedit-gtksourceview
  ];

  meta = with lib; {
    homepage = "https://github.com/gedit-technology/libgedit-tepl";
    description = "Text editor product line";
    maintainers = with maintainers; [ manveru bobby285271 ];
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
