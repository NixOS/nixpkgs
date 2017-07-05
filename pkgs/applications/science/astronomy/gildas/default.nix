{ stdenv, fetchurl, gtk2 , pkgconfig , python27 , gfortran , python27Packages , lesstif , cfitsio , getopt , perl , groff }:

stdenv.mkDerivation rec {
  srcVersion = "jul17a";
  version = "20170701_a";
  name = "gildas-${version}";

  src = fetchurl {
    url = "http://www.iram.fr/~gildas/dist/gildas-src-${srcVersion}.tar.gz";
    sha256 = "060vha4af2xamk0fvriqr6rgq4zayy4k6l5y6kj3h5cv9b4yiqzq";
  };

  enableParallelBuilding = false;

  nativeBuildInputs = [ pkgconfig groff perl getopt gfortran python27 python27Packages.numpy ];

  buildInputs = [ gtk2 lesstif cfitsio ];

  patches = [ ./format-security.patch ./wrapper.patch ];

  configurePhase=''
    substituteInPlace admin/wrapper.sh --replace '%%OUT%%' $out
    source admin/gildas-env.sh -b gcc -c gfortran -o openmp
    export GAG_INC_FLAGS=""
  '';

  buildPhase="make install";

  installPhase=''
    mkdir -p $out/bin
    cp -a ../gildas-exe-${srcVersion}/* $out
    mv $out/$GAG_EXEC_SYSTEM $out/libexec
    cp admin/wrapper.sh $out/bin/gildas-wrapper.sh
    chmod 755 $out/bin/gildas-wrapper.sh
    for i in $out/libexec/bin/* ; do
      ln -s $out/bin/gildas-wrapper.sh $out/bin/$(basename "$i")
    done
  '';

  meta = {
    description = "Radioastronomy data analysis software";
    longDescription = ''
      GILDAS is a collection of state-of-the-art software
      oriented toward (sub-)millimeter radioastronomical
      applications (either single-dish or interferometer).
      It is daily used to reduce all data acquired with the
      IRAM 30M telescope and Plateau de Bure Interferometer
      PDBI (except VLBI observations). GILDAS is easily
      extensible. GILDAS is written in Fortran-90, with a
      few parts in C/C++ (mainly keyboard interaction,
      plotting, widgets).'';
    homepage = http://www.iram.fr/IRAMFR/GILDAS/gildas.html;
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.all;
  };

}
