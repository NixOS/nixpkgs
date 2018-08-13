{ avahiSupport ? false # build support for Avahi in libinfinity
, stdenv, fetchurl, fetchFromGitHub, autoconf, automake, pkgconfig, wrapGAppsHook
, gtkmm3, gsasl, gtksourceview3, libxmlxx, libinfinity, intltool, itstool, gnome3 }:

let
  libinf = libinfinity.override { gtkWidgets = true; inherit avahiSupport; };
in stdenv.mkDerivation rec {
  name = "gobby-unstable-2018-04-03";
  src = fetchFromGitHub {
    owner = "gobby";
    repo = "gobby";
    rev = "ea4df27c9b6b885434797b0071ce198b23f9f63b";
    sha256 = "0q7lq64yn16lxvj4jphs8y9194h0xppj8k7y9x8b276krraak2az";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig intltool itstool gnome3.yelp-tools wrapGAppsHook ];
  buildInputs = [ gtkmm3 gsasl gtksourceview3 libxmlxx libinf ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://gobby.0x539.de/;
    description = "A GTK-based collaborative editor supporting multiple documents in one session and a multi-user chat";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}
