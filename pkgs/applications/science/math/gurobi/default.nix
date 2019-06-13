{ stdenv, fetchurl, autoPatchelfHook, python }:

stdenv.mkDerivation rec {
  name = "gurobi-${version}";
  version = "8.1.0";

  src = with stdenv.lib; fetchurl {
    url = "http://packages.gurobi.com/${versions.majorMinor version}/gurobi${version}_linux64.tar.gz";
    sha256 = "1yjqbzqnq4jjkjm616d36bgd3rmqr0a1ii17n0prpdjzmdlq63dz";
  };

  sourceRoot = "gurobi${builtins.replaceStrings ["."] [""] version}/linux64";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ (python.withPackages (ps: [ ps.gurobipy ])) ];

  buildPhase = ''
    cd src/build
    make
    cd ../..
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/
    rm $out/bin/gurobi.env
    rm $out/bin/gurobi.sh
    rm $out/bin/python2.7

    cp lib/gurobi.py $out/bin/gurobi.sh

    mkdir -p $out/include
    cp include/gurobi*.h $out/include/

    mkdir -p $out/lib
    cp lib/*.jar $out/lib/
    cp lib/libGurobiJni*.so $out/lib/
    cp lib/libgurobi*.so* $out/lib/
    cp lib/libgurobi*.a $out/lib/
    cp src/build/*.a $out/lib/

    mkdir -p $out/share/java
    ln -s $out/lib/gurobi.jar $out/share/java/
    ln -s $out/lib/gurobi-javadoc.jar $out/share/java/
  '';

  meta = with stdenv.lib; {
    description = "Optimization solver for mathematical programming";
    homepage = https://www.gurobi.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
