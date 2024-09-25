{ stdenv
, lib
, fetchFromGitHub
, fetchzip
, addDriverRunpath
, cmake
, glibc_multi
, glibc
, git
, pkg-config
, cudaPackages ? {}
, withCuda ? false
}:

let
  inherit (cudaPackages) cudatoolkit;

  hwloc = stdenv.mkDerivation rec {
    pname = "hwloc";
    version = "2.2.0";

    src = fetchzip {
      url = "https://download.open-mpi.org/release/hwloc/v${lib.versions.majorMinor version}/hwloc-${version}.tar.gz";
      sha256 = "1ibw14h9ppg8z3mmkwys8vp699n85kymdz20smjd2iq9b67y80b6";
    };

    configureFlags = [
      "--enable-static"
      "--disable-libudev"
      "--disable-shared"
      "--disable-doxygen"
      "--disable-libxml2"
      "--disable-cairo"
      "--disable-io"
      "--disable-pci"
      "--disable-opencl"
      "--disable-cuda"
      "--disable-nvml"
      "--disable-gl"
      "--disable-libudev"
      "--disable-plugin-dlopen"
      "--disable-plugin-ltdl"
    ];

    nativeBuildInputs = [ pkg-config ];

    enableParallelBuilding = true;

    outputs = [ "out" "lib" "dev" "doc" "man" ];
  };

in
stdenv.mkDerivation rec {
  pname = "firestarter";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    rev = "v${version}";
    sha256 = "1ik6j1lw5nldj4i3lllrywqg54m9i2vxkxsb2zr4q0d2rfywhn23";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ] ++ lib.optionals withCuda [
    addDriverRunpath
  ];

  buildInputs = [ hwloc ] ++ (if withCuda then
    [ glibc_multi cudatoolkit ]
  else
    [ glibc.static ]);

  NIX_LDFLAGS = lib.optionals withCuda [
    "-L${cudatoolkit}/lib/stubs"
  ];

  cmakeFlags = [
    "-DFIRESTARTER_BUILD_HWLOC=OFF"
    "-DCMAKE_C_COMPILER_WORKS=1"
    "-DCMAKE_CXX_COMPILER_WORKS=1"
  ] ++ lib.optionals withCuda [
    "-DFIRESTARTER_BUILD_TYPE=FIRESTARTER_CUDA"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/FIRESTARTER${lib.optionalString withCuda "_CUDA"} $out/bin/
    runHook postInstall
  '';

  postFixup = lib.optionalString withCuda ''
    addDriverRunpath $out/bin/FIRESTARTER_CUDA
  '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://tu-dresden.de/zih/forschung/projekte/firestarter";
    description = "Processor Stress Test Utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro marenz ];
    license = licenses.gpl3;
    mainProgram = "FIRESTARTER";
  };
}
