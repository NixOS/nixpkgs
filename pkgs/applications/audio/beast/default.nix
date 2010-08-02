{ stdenv, fetchurl, zlib, guile, libart_lgpl, pkgconfig, intltool
, gtk, glib, libogg, libvorbis, libgnomecanvas, gettext, perl }:

stdenv.mkDerivation {
  name = "beast-0.7.1";

  src = fetchurl {
    url = ftp://beast.gtk.org/pub/beast/v0.7/beast-0.7.1.tar.bz2;
    sha256 = "0jyl1i1918rsn4296w07fsf6wx3clvad522m3bzgf8ms7gxivg5l";
  };

  buildInputs =
    [ zlib guile libart_lgpl pkgconfig intltool gtk glib
      libogg libvorbis libgnomecanvas gettext
    ];

  patchPhase = ''
    unset patchPhase; patchPhase
    sed 's=-DG_DISABLE_DEPRECATED==g' -i `find -type f` # the patches didn't remove all occurences
    sed 's=/bin/bash=/${stdenv.shell}=g' -i `find -type f`
    sed 's=/usr/bin/perl=/${perl}/bin/perl=g' -i `find -type f`
  '';

  patches =
    [ (fetchurl {
        url = mirror://gentoo/distfiles/beast-0.7.1-guile-1.8.diff.bz2;
        sha256 = "dc5194deff4b0a0eec368a69090db682d0c3113044ce2c2ed017ddfec9d3814e";
      })
      ./patch.patch # patches taken from gentoo
    ];

  meta = { 
    description = "BEAST - the Bedevilled Sound Engine";
    homepage = http://beast.gtk.org;
    license = ["GPL-2" "LGPL-2.1"];
  };
}
