{ stdenv, fetchurl, frei0r, lib, cmake, qt4, perl, kdelibs, automoc4
, phonon , makeWrapper, mlt, gettext , qimageblitz, qjson
, shared_mime_info, soprano, pkgconfig, shared_desktop_ontologies
, libv4l
}:

stdenv.mkDerivation rec {
  name = "kdenlive-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "mirror://kde/stable/kdenlive/${version}/src/${name}.tar.bz2";
    sha256 = "17x5srgywcwlbpbs598jwwc62l8313n4dbqx3sdk7p6lyvwk3jln";
  };

  buildInputs = [
    automoc4 cmake frei0r gettext kdelibs libv4l makeWrapper mlt perl
    phonon pkgconfig qimageblitz qjson qt4 shared_desktop_ontologies
    shared_mime_info soprano
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/kdenlive --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
    wrapProgram $out/bin/kdenlive_render  --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
  '';

  meta = {
    description = "Free and open source video editor";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [ goibhniu viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
