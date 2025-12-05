{ lib, stdenv, fetchurl, zlib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "gdstk";
  version = "0.9.61";
  
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/74/72/cc46f132741e541995ede7fccf9820f105fb2296ab70192bd27de56190f2/gdstk-0.9.61-cp313-cp313-manylinux_2_28_x86_64.whl";
    sha256 = "+rZ8zdgCnvfrhz+MmPh13CZlpeRa9889KnoPQBgmodM=";
  };
  
  # 🔑 CRITICAL FIX: Include C runtime dependencies.
  buildInputs = [
    zlib # For libz.so.1
    stdenv.cc.cc.lib # <--- ADDED: For libstdc++.so.6
  ];

  propagatedBuildInputs = [
    python3Packages.numpy
  ];

  # 🔑 CRITICAL FIX: Custom phase to manually set LD_LIBRARY_PATH for all C/C++ dependencies.
  pythonImportsCheckPhase = ''
    echo "Running custom pythonImportsCheckPhase with explicit LD_LIBRARY_PATH"
    
    # Explicitly set the path for libz.so.1 AND libstdc++.so.6
    export LD_LIBRARY_PATH="${zlib}/lib:${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
    
    # Execute the import check command manually
    ${python3Packages.python.interpreter} -c '
import sys; 
import importlib; 
list(map(lambda mod: importlib.import_module(mod), sys.argv[1:]))
' gdstk
  '';

  meta = with lib; {
    description = "C++ library and Python module for creation and manipulation of GDSII and OASIS files";
    homepage = "https://github.com/heitzmann/gdstk";
    license = licenses.bsl11;
    maintainers = [ maintainers.gonsolo ];
  };
}
