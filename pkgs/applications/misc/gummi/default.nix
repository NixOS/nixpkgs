{ stdenv, pkgs
, glib, gnome3, gtk3, gtksourceview3, gtkspell3, poppler, texlive
, pkgconfig, intltool, autoreconfHook, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.8.1";
  pname = "gummi";

  src = pkgs.fetchFromGitHub {
    owner = "alexandervdm";
    repo = "gummi";
    rev = version;
    sha256 = "0wxgmzazqiq77cw42i5fn2hc22hhxf5gbpl9g8y3zlnp21lw9y16";
  };

  nativeBuildInputs = [
    pkgconfig intltool autoreconfHook wrapGAppsHook
  ];
  buildInputs = [
    glib gtksourceview3 gtk3 gtkspell3 poppler
    texlive.bin.core # needed for synctex
  ];

  postInstall = ''
    install -Dpm644 COPYING $out/share/licenses/$name/COPYING
  '';

  meta = {
    homepage = "https://gummi.app";
    description = "Simple LaTex editor for GTK users";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ flokli ];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
