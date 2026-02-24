{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  cmake,
  freetype,
  gfortran,
  openssl,
  libnsl,
  motif,
  xorg,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  version = "2024.06.12.0";
  pname = "cernlib";
  year = lib.versions.major version;

  src = fetchurl {
    urls = [
      "https://ftp.riken.jp/cernlib/download/${year}_source/tar/cernlib-cernlib-${version}-free.tar.gz"
      "https://cernlib.web.cern.ch/download/${year}_source/tar/cernlib-cernlib-${version}-free.tar.gz"
    ];
    hash = "sha256-SEFgQjPBkmRoaMD/7yXiXO9DZNrRhqZ01kptSDQur84=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/user-attachments/files/16832928/geant321-fix-weak-alias-on-darwin.patch";
      hash = "sha256-YzaUh4rJBszGdp5s/HDQMI5qQhCGrTt9P6XCgZOFn1I=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3.0 FATAL_ERROR)" \
                     "cmake_minimum_required(VERSION 3.10.0 FATAL_ERROR)" \
      --replace-fail "find_program ( SED NAMES gsed" "find_program ( SED NAMES sed"
  '';

  # gfortran warning's on iframework messes with CMake's check_fortran_compiler_flag
  # see also https://github.com/NixOS/nixpkgs/issues/27218
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$(echo $NIX_CFLAGS_COMPILE | sed 's|-iframework [^ ]*||g')"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs =
    with xorg;
    [
      freetype
      gfortran
      openssl
      libX11
      libXaw
      libXft
      libXt
      libxcrypt
      motif
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux libnsl;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://cernlib.web.cern.ch";
    description = "Legacy collection of libraries and modules for data analysis in high energy physics";
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ veprbl ];
    license = lib.licenses.gpl2;
  };
}
