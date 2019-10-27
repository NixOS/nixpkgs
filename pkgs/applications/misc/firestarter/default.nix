{ stdenv, fetchFromGitHub, python3, cudatoolkit,
  withCuda ? true
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "firestarter";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    rev = "v${version}";
    sha256 = "1gc7kmzx9nw22lyfmpyz72p974jf1hvw5nvszcaq7x6h8cz9ip15";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = optionals withCuda [ cudatoolkit ];
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
    homepage = https://tu-dresden.de/zih/forschung/projekte/firestarter;
    description = "Processor Stress Test Utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
    license = licenses.gpl3;
  };
}
