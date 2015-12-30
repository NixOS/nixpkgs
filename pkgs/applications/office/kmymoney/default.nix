{ stdenv, fetchurl, cmake, kdelibs, automoc4, kdepimlibs, gettext, pkgconfig
, shared_mime_info, perl, boost, gpgme, gmpxx, libalkimia, libofx, libical
, oxygen_icons, kactivities, aqbanking, perlPackages, gwenhywfar }:

stdenv.mkDerivation rec {
  name = "kmymoney-4.7.2";

  src = fetchurl {
    url = http://kde.mirrorcatalogs.com/stable/kmymoney/4.7.2/src/kmymoney-4.7.2.tar.xz;
    #sha256 = "7749cbae146eb4adf5c92162c841ae321f971c5720bc32d0227a42a4dd4acfc4"; # v. 4.7.1
    sha256 = "bfb2c29ff30988f46324c2dae197a06b58d07336a1947adc22bcfed3e554393d"; # v. 4.7.2
  };

  buildInputs = [ kdepimlibs perl boost gpgme gmpxx libalkimia libofx libical
                  oxygen_icons kactivities shared_mime_info aqbanking
                  perlPackages.FinanceQuote gwenhywfar ];
  nativeBuildInputs = [ cmake automoc4 gettext pkgconfig ]; 

  #KDEDIRS = libalkimia;
  KDEDIRS="$out:${libalkimia}:${gwenhywfar}:${aqbanking}";

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
