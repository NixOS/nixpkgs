{ stdenv, fetchurl, gtk2, which, pkgconfig, intltool }:

let
  version = "1.23";
in

stdenv.mkDerivation rec {
  name = "geany-${version}";

  src = fetchurl {
    url = "http://download.geany.org/${name}.tar.bz2";
    sha256 = "1c78rggjaz9fa8gj25wka1sa3argvixnzrarmqvwh0s8d5ragm6d";
  };

  buildInputs = [ gtk2 which pkgconfig intltool ];

  doCheck = true;

  enableParallelBuilding = true;

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
    homepage = "http://www.geany.org/";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
