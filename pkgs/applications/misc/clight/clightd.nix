{ lib, stdenv, fetchFromGitHub
, dbus, cmake, pkg-config
, glib, udev, polkit, libusb1, libjpeg, libmodule
, pcre, libXdmcp, util-linux, libpthreadstubs
, enableDdc ? true, ddcutil
, enableDpms ? true, libXext
, enableGamma ? true, libdrm, libXrandr, wayland
, enableScreen ? true
, enableYoctolight ? true }:

stdenv.mkDerivation rec {
  pname = "clightd";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clightd";
    rev = version;
    sha256 = "sha256-PxYOI/2ZOz3JSGCPIXfm3WfGZ19D8JhhdNS3FVuXus8=";
  };

  # dbus-1.pc has datadir=/etc
  SYSTEM_BUS_DIR = "${placeholder "out"}/share/dbus-1/system-services";
  # polkit-gobject-1.pc has prefix=${polkit.out}
  POLKIT_ACTION_DIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    sed -i "s@pkg_get_variable(SYSTEM_BUS_DIR.*@set(SYSTEM_BUS_DIR $SYSTEM_BUS_DIR)@" CMakeLists.txt
    sed -i "s@pkg_get_variable(POLKIT_ACTION_DIR.*@set(POLKIT_ACTION_DIR $POLKIT_ACTION_DIR)@" CMakeLists.txt
  '';

  cmakeFlags = with lib;
    [ "-DSYSTEMD_SERVICE_DIR=${placeholder "out"}/lib/systemd/system"
      "-DDBUS_CONFIG_DIR=${placeholder "out"}/etc/dbus-1/system.d"
      # systemd.pc has prefix=${systemd.out}
      "-DMODULE_LOAD_DIR=${placeholder "out"}/lib/modules-load.d"
    ] ++ optional enableDdc        "-DENABLE_DDC=1"
      ++ optional enableDpms       "-DENABLE_DPMS=1"
      ++ optional enableGamma      "-DENABLE_GAMMA=1"
      ++ optional enableScreen     "-DENABLE_SCREEN=1"
      ++ optional enableYoctolight "-DENABLE_YOCTOLIGHT=1";

  nativeBuildInputs = [
    dbus
    cmake
    pkg-config
  ];

  buildInputs = with lib; [
    glib
    udev
    polkit
    libusb1
    libjpeg
    libmodule

    pcre
    libXdmcp
    util-linux
    libpthreadstubs
  ] ++ optionals enableDdc [ ddcutil ]
    ++ optionals enableDpms [ libXext ]
    ++ optionals enableGamma [ libXrandr ]
    ++ optionals (enableDpms || enableGamma || enableScreen) [ libdrm wayland ];

  postInstall = ''
    mkdir -p $out/bin
    ln -svT $out/libexec/clightd $out/bin/clightd
  '';

  meta = with lib; {
    description = "Linux bus interface that changes screen brightness/temperature";
    homepage = "https://github.com/FedeDP/Clightd";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
