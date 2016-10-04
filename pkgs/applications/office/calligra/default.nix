{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig, kdelibs, lcms2, libpng, eigen
, exiv2, boost, sqlite, icu, vc, shared_mime_info, librevenge, libodfgen, libwpg
, libwpd, poppler_qt4, ilmbase, gsl, qca2, marble, libvisio, libmysql, postgresql
, freetds, fftw, glew, libkdcraw, pstoedit, opencolorio, kdepimlibs
, kactivities, okular, git, oxygen_icons, makeWrapper
# TODO: not found
#, xbase, openjpeg
# TODO: package libWPS, Spnav, m2mml, LibEtonyek
}:

stdenv.mkDerivation rec {
  name = "calligra-2.9.11";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.xz";
    sha256 = "02gaahp7a7m53n0hvrp3868s8w37b457isxir0z7b4mwhw7jv3di";
  };

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig makeWrapper ];

  buildInputs = [
    kdelibs lcms2 libpng eigen
    exiv2 boost sqlite icu vc shared_mime_info librevenge libodfgen libwpg
    libwpd poppler_qt4 ilmbase gsl qca2 marble libvisio libmysql postgresql
    freetds fftw glew libkdcraw opencolorio kdepimlibs
    kactivities okular git
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix PATH ':' "${pstoedit.out}/bin" \
        --prefix XDG_DATA_DIRS ':' "${oxygen_icons}/share"
    done
  '';

  meta = with stdenv.lib; {
    description = "A suite of productivity applications";
    longDescription = ''
      Calligra Suite is a set of applications written to help
      you to accomplish your work. Calligra includes efficient
      and capable office components: Words for text processing,
      Sheets for computations, Stage for presentations, Plan for
      planning, Flow for flowcharts, Kexi for database creation,
      Krita for painting and raster drawing, and Karbon for
      vector graphics.
    '';
    homepage = http://calligra.org;
    maintainers = with maintainers; [ urkud phreedom ebzzry ];
    inherit (kdelibs.meta) platforms;
    license = licenses.gpl2;
  };
}
