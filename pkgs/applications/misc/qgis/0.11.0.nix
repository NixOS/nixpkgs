args: with args;
let edf = composableDerivation.edf;
    optionIncLib = name : attr : " -D${name}_INCLUDE_DIR=${__getAttr attr args}/incclude"
                               + " -D${name}_LIBRARY=${__getAttr attr args}/lib "; # lib 64?
in
composableDerivation.composableDerivation {} {

  buildInputs = [ gdal cmake qt flex bison proj geos x11 sqlite gsl];
    cfgOption = [
                  # without this option it can't find sqlite libs yet (missing symbols..) (TODO)
                  "-DWITH_INTERNAL_SQLITE3=TRUE"
                ];

  name = "qgis-${version}";

  # src = args.fetchsvn { url=https://svn.qgis.org/repos/qgis/trunk/qgis;
  #                md5="ac0560e0a2d4e6258c8639f1e9b56df3"; rev="7704"; };
  src = fetchurl {
    url = "http://download.osgeo.org/qgis/src/qgis_${version}.tar.gz";
    sha256 = "17vqbld4wr9jyn1s5n0bkpaminsgc2dzcgdfk8ic168xydnwa7b3";
  };

  meta = {
    description = "user friendly Open Source Geographic Information System";
    homepage = http://www.qgis.org;
    # you can choose one of the following licenses:
    license = [ "GPL" ];
  };

  phases = "unpackPhase buildPhase installPhase";
  buildPhase = ''pwd;echo XXXXXXXXX; VERBOSE=1 cmake -DCMAKE_INSTALL_PREFIX=$out ''${cfgOption} ..'';

  postUnpack = ''
    export CMAKE_SYSTEM_LIBRARY_PATH=
    for i in $buildInputs $propagatedBuildInputs; do
      CMAKE_SYSTEM_LIBRARY_PATH=$i/lib:$CMAKE_SYSTEM_LIBRARY_PATH
    done
  '';

  #configurePhase="./autogen.sh --prefix=\$out --with-gdal=\$gdal/bin/gdal-config --with-qtdir=\$qt";
  # buildPhases="unpackPhase buildPhase";

}
