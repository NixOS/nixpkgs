{ stdenv, fetchurl, autoPatchelfHook, python }:

stdenv.mkDerivation rec {
  name = "gurobi-${version}";
  version = "8.0.1";

  src = with stdenv.lib; fetchurl {
    url = "http://packages.gurobi.com/${versions.majorMinor version}/gurobi${version}_linux64.tar.gz";
    sha256 = "0y3lb0mngnyn7ql4s2n8qxnr1d2xcjdpdhpdjdxc4sc8f2w2ih18";
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
    cp lib/libgurobi*.so* $out/lib/
    cp lib/libgurobi*.a $out/lib/
    cp src/build/*.a $out/lib/
  '';

  meta = with stdenv.lib; {
    description = "Optimization solver for mathematical programming";
    homepage = https://www.gurobi.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
