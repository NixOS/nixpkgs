{ stdenv, fetchurl, lib, cmake, qt4, perl, lcms, exiv2, libxml2, libxslt, boost, glew
, shared_mime_info, popplerQt4, gsl, gmm, wv2, libwpd, libwpg,  giflib, libgsf
, fftw, pkgconfig, openjpeg , kdelibs, kdepimlibs, automoc4, phonon
, qimageblitz, qca2, eigen, soprano , kdegraphics}:

stdenv.mkDerivation rec {
  name = "koffice-2.2.2";
  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.bz2";
    sha256 = "1jzdq7av4vbfkx987yz54431q3bwrsd7wzyinl9wsznx83v61c75";
  }; 

  patchFlags = "-p0";
  patches =
    let
      urlBase = "http://kexi-project.org/download/patches/2.2.2/";
    in
    [
      (fetchurl {
        url = "${urlBase}support-large-memo-values-for-msaccess-2.2.2.patch";
        sha256 = "1jn6na8c0vdf87p0yv9bcff0kd1jmcxndxmm3s0878l5pak9m8rd";
      })
      (fetchurl {
        url = "${urlBase}fix-crash-on-closing-sqlite-connection-2.2.2.patch";
        sha256 = "11h4rxdrv5vakym5786vr4bysi4627m53qqvk1vhxf3rkawvcafj";
      })
      ./wpd.patch
      ./krita-exiv-0.21.diff
    ];

  buildInputs = [ cmake qt4 perl lcms exiv2 libxml2 libxslt boost glew
    shared_mime_info popplerQt4 gsl gmm wv2 libwpd libwpg giflib libgsf
    stdenv.gcc.libc fftw pkgconfig kdelibs kdepimlibs automoc4 phonon
    qimageblitz qca2 eigen openjpeg soprano kdegraphics ];

  meta = {
    description = "KDE integrated Office Suite";
    license = "GPL";
    homepage = http://www.koffice.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    # doesn't build, seems dead and superseded by calligra
    #inherit (kdelibs.meta) platforms;
  };
}
