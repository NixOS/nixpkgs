{ stdenv, fetchurl
, automoc4, cmake, gettext, makeWrapper, perl, pkgconfig
, kdelibs, cairo, dbus_glib, mplayer
}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.3d";

  src = fetchurl {
    #url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.3d.tar.bz2;
    url = "mirror://gentoo/distfiles/kmplayer-0.11.3d.tar.bz2";
    sha256 = "1yvbkb1hh5y7fqfvixjf2rryzm0fm0fpkx4lmvhi7k7d0v4wpgky";
  };

  buildInputs = [ kdelibs cairo dbus_glib ];

  nativeBuildInputs = [ automoc4 cmake gettext makeWrapper perl pkgconfig ];

  postInstall = ''
    wrapProgram $out/bin/kmplayer --suffix PATH : ${mplayer}/bin
  '';

  meta = {
    description = "MPlayer front-end for KDE";
    license = "GPL";
    homepage = http://kmplayer.kde.org;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
