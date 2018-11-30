{ stdenv, fetchurl, gtk2, which, pkgconfig, intltool, file, libintl, hicolor-icon-theme }:

with stdenv.lib;

let
  version = "1.33";
in

stdenv.mkDerivation rec {
  name = "geany-${version}";

  src = fetchurl {
    url = "https://download.geany.org/${name}.tar.bz2";
    sha256 = "66baaff43f12caebcf0efec9a5533044dc52837f799c73a1fd7312caa86099c2";
  };

  nativeBuildInputs = [ pkgconfig intltool libintl ];
  buildInputs = [ gtk2 which file hicolor-icon-theme ];

  doCheck = true;

  enableParallelBuilding = true;

  patchPhase = "patchShebangs .";

  meta = {
    description = "Small and lightweight IDE";
    longDescription = ''
      Geany is a small and lightweight Integrated Development Environment.
      It was developed to provide a small and fast IDE, which has only a few dependencies from other packages.
      Another goal was to be as independent as possible from a special Desktop Environment like KDE or GNOME.
      Geany only requires the GTK2 runtime libraries.
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
    homepage = https://www.geany.org/;
    license = licenses.gpl2;
    maintainers = [];
    platforms = platforms.all;
  };
}
