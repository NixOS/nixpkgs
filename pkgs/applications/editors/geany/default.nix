{ stdenv, fetchurl, gtk2, which, pkgconfig, intltool, file }:

with stdenv.lib;

let
  version = "1.32";
in

stdenv.mkDerivation rec {
  name = "geany-${version}";

  src = fetchurl {
    url = "http://download.geany.org/${name}.tar.bz2";
    sha256 = "8b7be10b95d0614eb07f845ba2280f7c026eacd5739d8fac4d5d26606f8c3c2d";
  };

  NIX_LDFLAGS = if stdenv.isDarwin then "-lintl" else null;

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ gtk2 which file ];

  doCheck = true;

  enableParallelBuilding = true;

  patchPhase = "patchShebangs .";

  # This file should normally require a gtk-update-icon-cache -q /usr/share/icons/hicolor command
  # It have no reasons to exist in a redistribuable package
  postInstall = "rm $out/share/icons/hicolor/icon-theme.cache";

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
    homepage = http://www.geany.org/;
    license = "GPL";
    maintainers = [];
    platforms = platforms.all;
  };
}
