{
  stdenv,
  lib,
  libuuid,
  fetchFromGitHub,
  libsystemtap,
  cmake,
  pkg-config,
  libdrm,
  keepBuildTree,
  gitMinimal,
  ocl-icd,
  boost,
  curl,
  systemd,
  rapidjson,
  openssl,
  opencl-headers,
  ncurses,
  protobuf,
  perl,
  elfutils,
  plugins ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrt";
  version = "2.21.75";

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "XRT";
    hash = "sha256-sujiSRZuIelhvUew7yeCfApAmp/Pf2+F38KO9cxI2HE=";
    tag = finalAttrs.version;
    fetchSubmodules = true;
  };

  inherit plugins;

  cmakeFlags = [
    "-DXRT_UPSTREAM_DEBIAN=1"
    "-DAIEBU_UPSTREAM=1"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_SBINDIR=sbin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_DATADIR=share"
    "-DCMAKE_INSTALL_INFODIR=share/info"
    "-DCMAKE_INSTALL_MANDIR=share/man"
    "-DCMAKE_INSTALL_DOCDIR=share/doc/${finalAttrs.pname}"
    "-DCMAKE_INSTALL_LOCALEDIR=share/locale"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    keepBuildTree
    perl
    gitMinimal
  ];

  postPatch = ''
    # Redirect DKMS install from hardcoded /usr/src to the output directory
    substituteInPlace src/CMake/version.cmake \
      --replace-fail \
        'set (XRT_DKMS_INSTALL_DIR "/usr/src/xrt-''${XRT_VERSION_STRING}")' \
        'set (XRT_DKMS_INSTALL_DIR "''${CMAKE_INSTALL_PREFIX}/share/xrt-dkms/xrt-''${XRT_VERSION_STRING}")'
    substituteInPlace src/CMake/dkms-aws.cmake \
      --replace-fail \
        'set(XRT_DKMS_AWS_INSTALL_DIR "/usr/src/xrt-aws-''${XRT_VERSION_STRING}")' \
        'set(XRT_DKMS_AWS_INSTALL_DIR "''${CMAKE_INSTALL_PREFIX}/share/xrt-dkms/xrt-aws-''${XRT_VERSION_STRING}")'

    # OpenCL ICD file goes to /etc/OpenCL/vendors by default; redirect to output
    substituteInPlace src/CMake/icd.cmake \
      --replace-fail \
        'set(OCL_ICD_INSTALL_PREFIX "/etc/OpenCL/vendors")' \
        'set(OCL_ICD_INSTALL_PREFIX "''${CMAKE_INSTALL_PREFIX}/etc/OpenCL/vendors")'

    # CMAKE_INSTALL_LIBDIR is an absolute path in nixpkgs, causing a double slash in xrt.pc
    substituteInPlace src/CMake/config/xrt.pc.in \
      --replace-fail \
        'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' \
        'libdir=@CMAKE_INSTALL_FULL_LIBDIR@'

    # xbflash tools install to /usr/local/bin
    substituteInPlace src/runtime_src/core/pcie/tools/xbflash.qspi/CMakeLists.txt \
      --replace-fail \
        'set(XBFLASH_INSTALL_DEST "/usr/local/bin")' \
        'set(XBFLASH_INSTALL_DEST "''${CMAKE_INSTALL_PREFIX}/bin")'
    substituteInPlace src/runtime_src/core/tools/xbflash2/CMakeLists.txt \
      --replace-fail \
        'set(XBFLASH_INSTALL_DEST "/usr/local/bin")' \
        'set(XBFLASH_INSTALL_DEST "''${CMAKE_INSTALL_PREFIX}/bin")'
  '';

  postInstall = ''
    for plugin in $plugins; do
      cp $plugin/lib/* $out/lib/
    done
  '';

  buildInputs = [
    libdrm
    libuuid
    ocl-icd
    boost
    rapidjson
    libsystemtap
    opencl-headers
    curl
    ncurses
    openssl
    protobuf
    systemd
    elfutils
  ];

  meta = {
    description = "Xilinx Runtime for FPGA and accelerator devices";
    homepage = "https://github.com/Xilinx/XRT";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ schmitthenner ];
    platforms = [ "x86_64-linux" ];
  };
})
