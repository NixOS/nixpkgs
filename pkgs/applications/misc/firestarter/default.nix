{ stdenv, fetchFromGitHub, glibc, python3, cudatoolkit,
  withCuda ? true
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "firestarter";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    rev = "v${version}";
    sha256 = "0zqfqb7hf48z39g1qhbl1iraf8rz4d629h1q6ikizckpzfq23kd0";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [ glibc.static ] ++ optionals withCuda [ cudatoolkit ];
  preBuild = ''
    mkdir -p build
    cd build
    python ../code-generator.py ${optionalString withCuda "--enable-cuda"}
  '';
  makeFlags = optionals withCuda [ "LINUX_CUDA_PATH=${cudatoolkit}" ];
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp FIRESTARTER $out/bin/firestarter
  '';

  meta = with stdenv.lib; {
    homepage = "https://tu-dresden.de/zih/forschung/projekte/firestarter";
    description = "Processor Stress Test Utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro marenz ];
    license = licenses.gpl3;
  };
}
