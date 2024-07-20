{ stdenv, lib, fetchurl, autoPatchelfHook, python3 }:

stdenv.mkDerivation rec {
  pname = "gurobi";
  version = "11.0.2";

  src = fetchurl {
    url = "https://packages.gurobi.com/${lib.versions.majorMinor version}/gurobi${version}_linux64.tar.gz";
    hash = "sha256-9DrIo+25h7mgphRSrNnY2+nrNzaMbafONuUkfLKho2g=";
  };

  sourceRoot = "gurobi${builtins.replaceStrings ["."] [""] version}/linux64";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ (python3.withPackages (ps: [ ps.gurobipy ])) ];

  strictDeps = true;

  makeFlags = [ "--directory=src/build" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/
    rm $out/bin/gurobi.sh
    rm $out/bin/python*

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

  passthru.libSuffix = lib.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version);

  meta = with lib; {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.gurobi.com";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ wegank ];
  };
}
