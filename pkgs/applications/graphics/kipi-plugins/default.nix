{ stdenv, fetchurl, kdelibs, qimageblitz, qca2, libkexiv2, libkdcraw, libkipi
, libksane, kdepimlibs, libxml2, libxslt, gettext, opencv, libgpod, gdk_pixbuf
, qjson , pkgconfig }:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.9.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "0k4k9v1rj7129n0s0i5pvv4rabx0prxqs6sca642fj95cxc6c96m";
  };

  buildInputs =
    [ kdelibs libkexiv2 libkdcraw libkipi qimageblitz qca2 kdepimlibs libxml2
      libksane libxslt gettext opencv libgpod gdk_pixbuf qjson
    ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    inherit (kdelibs.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
  };
}
