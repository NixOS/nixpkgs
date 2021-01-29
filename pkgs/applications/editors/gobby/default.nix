{ avahiSupport ? false # build support for Avahi in libinfinity
, lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, wrapGAppsHook, yelp-tools
, gtkmm3, gsasl, gtksourceview3, libxmlxx, libinfinity, intltool, itstool, gnome3 }:

let
  libinf = libinfinity.override { gtkWidgets = true; inherit avahiSupport; };
in stdenv.mkDerivation {
  pname = "gobby";
  version = "unstable-2020-12-29";

  src = fetchFromGitHub {
    owner = "gobby";
    repo = "gobby";
    rev = "49bfd3c3aa82e6fe9b3d59c3455d7eb4b77379fc";
    sha256 = "1p2f2rid7c0b9gvmywl3r37sxx57wv3r1rxvs1rwihmf9rkqnfxg";
  };

  nativeBuildInputs = [ autoconf automake pkg-config intltool itstool yelp-tools wrapGAppsHook ];
  buildInputs = [ gtkmm3 gsasl gtksourceview3 libxmlxx libinf ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "http://gobby.0x539.de/";
    description = "A GTK-based collaborative editor supporting multiple documents in one session and a multi-user chat";
    license = lib.licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}
