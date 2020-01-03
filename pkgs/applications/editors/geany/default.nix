{ stdenv
, fetchurl
, gtk3
, which
, pkgconfig
, intltool
, file
, libintl
, hicolor-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "geany";
  version = "1.36";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://download.geany.org/${pname}-${version}.tar.bz2";
    sha256 = "0gnm17cr4rf3pmkf0axz4a0fxwnvp55ji0q0lzy88yqbshyxv14i";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libintl
    which
    file
    hicolor-icon-theme
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Small and lightweight IDE";
    longDescription = ''
      Geany is a small and lightweight Integrated Development Environment.
      It was developed to provide a small and fast IDE, which has only a few dependencies from other packages.
      Another goal was to be as independent as possible from a special Desktop Environment like KDE or GNOME.
      Geany only requires the GTK runtime libraries.
      Some basic features of Geany:
      - Syntax highlighting
      - Code folding
      - Symbol name auto-completion
      - Construct completion/snippets
      - Auto-closing of XML and HTML tags
      - Call tips
      - Many supported filetypes including C, Java, PHP, HTML, Python, Perl, Pascal (full list)
      - Symbol lists
      - Code navigation
      - Build system to compile and execute your code
      - Simple project management
      - Plugin interface
    '';
    homepage = "https://www.geany.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ frlan ];
    platforms = platforms.all;
  };
}
