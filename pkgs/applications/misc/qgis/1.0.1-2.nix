args: with args;
let inherit (builtins) getAttr;
    edf = composableDerivation.edf;
    optionIncLib = name : attr : " -D${name}_INCLUDE_DIR=${getAttr attr args}/incclude"
                               + " -D${name}_LIBRARY=${getAttr attr args}/lib "; # lib 64?
in
composableDerivation.composableDerivation {} {

  buildInputs = [ gdal cmake qt flex bison proj geos x11 sqlite gsl];
    cfgOption = [
                  # without this option it can't find sqlite libs yet (missing symbols..) (TODO)
                  "-DWITH_INTERNAL_SQLITE3=TRUE"
                ];

  name = "qgis-1.0.1-2";

  # src = args.fetchsvn { url=https://svn.qgis.org/repos/qgis/trunk/qgis;
  #                md5="ac0560e0a2d4e6258c8639f1e9b56df3"; rev="7704"; };
  src = fetchurl {
    url = "http://download.osgeo.org/qgis/src/qgis_1.0.1-2.tar.gz";
    sha256 = "07yyic9sn1pz20wjk7k560jwqz6b19rhf2gawybz38xq1f8rjwd4";
  };

  meta = {
    description = "user friendly Open Source Geographic Information System";
    homepage = ttp://www.qgis.org;
    # you can choose one of the following licenses:
    license = [ "GPL" ];
  };

  phases = "unpackPhase buildPhase installPhase";
  buildPhase = ''pwd; mkdir build; cd build;  VERBOSE=1 cmake -DCMAKE_INSTALL_PREFIX=$out ''${cfgOption} ..'';

  postUnpack = ''
    export CMAKE_SYSTEM_LIBRARY_PATH=
    for i in $buildInputs $propagatedBuildInputs; do
      CMAKE_SYSTEM_LIBRARY_PATH=$i/lib:$CMAKE_SYSTEM_LIBRARY_PATH
    done
  '';

  #configurePhase="./autogen.sh --prefix=\$out --with-gdal=\$gdal/bin/gdal-config --with-qtdir=\$qt";
  # buildPhases="unpackPhase buildPhase";

}
