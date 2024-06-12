{ stdenv
, lib
, fetchFromGitHub
, fetchzip
, autoAddDriverRunpath
, cmake
, glibc_multi
, glibc
, git
, pkg-config
, cudaPackages ? {}
, withCuda ? false
}:

let
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeBool cmakeFeature optionalString;
  inherit (lib.versions) majorMinor;
  inherit (cudaPackages) cudatoolkit;

  hwloc = stdenv.mkDerivation (finalAttrs: {
    pname = "hwloc";
    version = "2.2.0";

    src = fetchzip {
      url = "https://download.open-mpi.org/release/hwloc/v${majorMinor finalAttrs.version}/hwloc-${finalAttrs.version}.tar.gz";
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
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "firestarter";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "tud-zih-energy";
    repo = "FIRESTARTER";
    rev = "v${finalAttrs.version}";
    sha256 = "1ik6j1lw5nldj4i3lllrywqg54m9i2vxkxsb2zr4q0d2rfywhn23";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ] ++ optionals withCuda [
    autoAddDriverRunpath
  ];

  buildInputs = [ hwloc ] ++ (if withCuda then
    [ glibc_multi cudatoolkit ]
  else
    [ glibc.static ]);

  NIX_LDFLAGS = optionals withCuda [
    "-L${cudatoolkit}/lib/stubs"
  ];

  cmakeFlags = [
    (cmakeBool "FIRESTARTER_BUILD_HWLOC" false)
    (cmakeBool "CMAKE_C_COMPILER_WORKS" true)
    (cmakeBool "CMAKE_CXX_COMPILER_WORKS" true)
  ] ++ optionals withCuda [
    (cmakeFeature "FIRESTARTER_BUILD_TYPE" "FIRESTARTER_CUDA")
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/FIRESTARTER${optionalString withCuda "_CUDA"} $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://tu-dresden.de/zih/forschung/projekte/firestarter";
    description = "Processor Stress Test Utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro marenz ];
    license = licenses.gpl3;
    mainProgram = "FIRESTARTER";
  };
})
