{ stdenv, pkgs, makeWrapper
, glib, gnome2, gnome3, gtk2-x11, gtkspell2, poppler
, pkgconfig, intltool, autoreconfHook, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.6.6";
  name = "gummi-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "alexandervdm";
    repo = "gummi";
    rev = "${version}";
    sha256 = "1vw8rhv8qj82l6l22kpysgm9mxilnki2kjmvxsnajbqcagr6s7cn";
  };

  nativeBuildInputs = [
    pkgconfig intltool autoreconfHook makeWrapper wrapGAppsHook
  ];
  buildInputs = [
    glib gnome2.gtksourceview gnome2.pango gtk2-x11 gtkspell2 poppler
    gnome3.defaultIconTheme
  ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${pkgs.gnome2.gtksourceview}/share")
  '';

  postInstall = ''
    install -Dpm644 COPYING $out/share/licenses/$name/COPYING
  '';

  meta = {
    homepage = http://gummi.midnightcoding.org/;
    description = "Simple LaTex editor for GTK users";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ flokli ];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
