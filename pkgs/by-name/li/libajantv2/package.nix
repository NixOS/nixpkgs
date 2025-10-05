{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  mbedtls,
  udev,
  linuxPackages,
}:

stdenv.mkDerivation rec {
  pname = "libajantv2";
  version = "17.5.0";

  src = fetchFromGitHub {
    owner = "aja-video";
    repo = "libajantv2";
    rev = "ntv2_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-/BfFbBScS75TpUZEeYzAHd1PtnZgnCNfGtjwYPJJjkg=";
  };
  patches = [
    ./use-system-mbedtls.patch
    ./device-info-list.patch
    ./musl.patch
    ./demos-ntv2overlay-no-makefile.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    mbedtls
    udev
  ];

  cmakeFlags = [
    (lib.cmakeBool "AJANTV2_BUILD_SHARED" true)
  ];

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/libajantv2.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include/libajantv2

    Name: libajantv2
    Description: Library for controlling AJA NTV2 video devices
    Version: ${version}
    Libs: -L\''${libdir} -lajantv2
    Cflags: -I\''${includedir} -I\''${includedir}/ajantv2/includes -I\''${includedir}/ajantv2/src/lin -DAJALinux -DAJA_LINUX -DAJA_USE_CPLUSPLUS11 -DNDEBUG -DNTV2_USE_CPLUSPLUS11
    EOF
  '';

  passthru.tests = {
    inherit (linuxPackages) ajantv2;
  };

  meta = with lib; {
    description = "AJA NTV2 Open Source Static Libs and Headers for building applications that only wish to statically link against";
    homepage = "https://github.com/aja-video/libajantv2";
    license = with licenses; [ mit ];
    maintainers = [ lib.maintainers.lukegb ];
    platforms = platforms.linux;
  };
}
