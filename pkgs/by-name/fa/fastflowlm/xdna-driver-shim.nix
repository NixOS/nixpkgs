{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  keepBuildTree,
  gitMinimal,
  perl,
  libuuid,
  libsystemtap,
  libdrm,
  ocl-icd,
  boost,
  curl,
  systemd,
  rapidjson,
  openssl,
  opencl-headers,
  ncurses,
  protobuf,
  elfutils,
  callPackage,
}:

let

  xrt = callPackage ./xrt.nix { plugins = [ xdna-driver-shim ]; };

  xdna-driver-shim = stdenv.mkDerivation (finalAttrs: {
    pname = "xdna-driver-shim";
    version = "2.21.75";

    src = fetchFromGitHub {
      owner = "amd";
      repo = "xdna-driver";
      rev = "beb9e450fe123ecdf395453971576179cedcf1dd";
      hash = "sha256-bBiI42bwap6O59MQdIylX7uz+fLUF75RTyNWTJfAFds="; # "sha256-pc9ou88iNAQpjcFvv9NluF8ag87v1KA/14bgfKWe0NE=";
      fetchSubmodules = true;
    };

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      cmake
      pkg-config
      keepBuildTree
      perl
      gitMinimal
    ];

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

    cmakeFlags = [
      "-DSKIP_KMOD=ON"
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

    postPatch = ''
      rm -rf xrt
      ln -s ${xrt.src} xrt

      # For shim-only builds, avoid the native packaging logic that assumes
      # distro packaging metadata, downloaded assets, and CPack.
      substituteInPlace CMake/native.cmake \
        --replace-fail \
          'include(''${CMAKE_CURRENT_SOURCE_DIR}/CMake/pkg.cmake)' \
          'set(XRT_PLUGIN_VERSION_STRING ''${XRT_VERSION_STRING})'

      # These installs are only for upstream quick-testing and reference
      # targets/destinations that are not meaningful in the Nix package.
      substituteInPlace src/shim/CMakeLists.txt \
        --replace-fail 'install(TARGETS ''${XRT_CORE_TARGET} DESTINATION ''${XDNA_BIN_DIR}/''${XDNA_PKG_LIB_DIR})' "" \
        --replace-fail 'install(TARGETS ''${XRT_COREUTIL_TARGET} DESTINATION ''${XDNA_BIN_DIR}/''${XDNA_PKG_LIB_DIR})' "" \
        --replace-fail 'install(TARGETS ''${XDNA_TARGET} DESTINATION ''${XDNA_BIN_DIR}/''${XDNA_PKG_LIB_DIR})' ""
    '';

    meta = {
      description = "AMD XDNA XRT shim library";
      homepage = "https://github.com/amd/xdna-driver";
      license = lib.licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  });
in
xrt
