{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical
, doxygen, oxygen_icons, kactivities }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.7.0";
  #name = "kmymoney-4.6.4";

  src = fetchurl {
#    url = "mirror://sourceforge/kmymoney2/${name}.tar.xz";
    url = http://ftp5.gwdg.de/pub/linux/kde/stable/kmymoney/4.7.0/src/kmymoney-4.7.0.tar.xz;
    sha256 = "e4b3ce10e2fe7d84314b7e1c77a995f41488d161b716f7d67ca8de715e833e09"; # v. 4.7.0
#    sha256 = "04n0lgi2yrx67bgjzbdbcm10pxs7l53srmp240znzw59njnjyll9"; # v 4.6.4
  };

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical
                  doxygen oxygen_icons kactivities shared_mime_info ];
  nativeBuildInputs = [ cmake automoc4 gettext pkgconfig ]; 

  KDEDIRS = libalkimia;

  postInstall = ''
    ln -s ${shared_mime_info}/share/mime/application/* $out/share/mime/application/
    ln -s ${shared_mime_info}/share/mime/inode $out/share/mime/inode
    ln -s ${oxygen_icons}/share/icons/oxygen/ $out/share/icons/oxygen
  '';

  patches = [ ./qgpgme.patch ];

  meta = {
    homepage = http://kmymoney2.sourceforge.net/;
    description = "KDE personal money manager";
    inherit (kdelibs.meta) platforms maintainers;
    priority = 100;
  };
}
