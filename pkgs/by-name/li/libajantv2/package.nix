{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  mbedtls,
  python3,
  alsa-lib,
  udev,
  linuxPackages,
  enableQt ? false,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libajantv2";
  version = "18.0.0";

  src = fetchFromGitHub {
    owner = "aja-video";
    repo = "libajantv2";
    rev = "ntv2_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-SdS2cV/jqSn1OMbRlvtQesXkV4ZAL5n1BIFl43p4WKQ=";
  };
  patches = [
    ./use-system-mbedtls.patch
    ./device-info-list.patch
    ./musl.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals enableQt [
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    mbedtls
    udev
    python3
    alsa-lib
  ]
  ++ lib.optionals enableQt [
    qt6.qtbase
    qt6.qtmultimedia
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "AJANTV2_BUILD_SHARED" true)
    (lib.cmakeBool "AJA_DISABLE_QT" (!enableQt))
  ];

  preFixup = lib.optionalString enableQt ''
    wrapQtApp "$out/bin/ntv2qtmultiinput"
    wrapQtApp "$out/bin/ntv2qtpreview"
  '';
  postInstall = ''
    mkdir -p "$dev/lib/pkgconfig"
    cat >"$dev/lib/pkgconfig/libajantv2.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=$dev/include/libajantv2

    Name: libajantv2
    Description: Library for controlling AJA NTV2 video devices
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lajantv2
    Cflags: -I\''${includedir} -I\''${includedir}/ajantv2/includes -I\''${includedir}/ajantv2/src/lin -DAJALinux -DAJA_LINUX -DAJA_USE_CPLUSPLUS11 -DNDEBUG -DNTV2_USE_CPLUSPLUS11
    EOF
  '';

  passthru.tests = {
    inherit (linuxPackages) ajantv2;
  };

  meta = {
    description = "AJA NTV2 Open Source Static Libs and Headers for building applications that only wish to statically link against";
    homepage = "https://github.com/aja-video/libajantv2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukegb ];
    platforms = lib.platforms.linux;
  };
})
