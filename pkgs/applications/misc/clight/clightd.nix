{ lib, stdenv, fetchFromGitHub, fetchpatch
, dbus, cmake, pkg-config
, glib, udev, polkit, libusb1, libjpeg, libmodule
, pcre, libXdmcp, util-linux, libpthreadstubs
, enableDdc ? true, ddcutil
, enableDpms ? true, libXext
, enableGamma ? true, libdrm, libXrandr, wayland
, enableScreen ? true }:

stdenv.mkDerivation rec {
  pname = "clightd";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clightd";
    rev = version;
    sha256 = "sha256-BEGum0t+FrCTAEQwTsWeYpoIqimTAz+Bv/ZQPQ3fePY=";
  };

  patches = [
    # Not needed by next version bump
    (fetchpatch {
      url = "https://github.com/FedeDP/Clightd/commit/a52a2888e3798c572dad359a017cb0d40e7c5fb7.patch";
      sha256 = "sha256-nUzNBia1EvBQxinAfjyKbuldBoHLY1hfMaxgG2lKQWg=";
    })
  ];

  # dbus-1.pc has datadir=/etc
  SYSTEM_BUS_DIR = "${placeholder "out"}/share/dbus-1/system-services";
  # systemd.pc has prefix=${systemd.out}
  MODULE_LOAD_DIR = "${placeholder "out"}/lib/modules-load.d";
  # polkit-gobject-1.pc has prefix=${polkit.out}
  POLKIT_ACTION_DIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    sed -i "s@/etc@$out\0@" CMakeLists.txt
    sed -i "s@pkg_get_variable(SYSTEM_BUS_DIR.*@set(SYSTEM_BUS_DIR $SYSTEM_BUS_DIR)@" CMakeLists.txt
    sed -i "s@pkg_get_variable(MODULE_LOAD_DIR.*@set(MODULE_LOAD_DIR $MODULE_LOAD_DIR)@" CMakeLists.txt
    sed -i "s@pkg_get_variable(POLKIT_ACTION_DIR.*@set(POLKIT_ACTION_DIR $POLKIT_ACTION_DIR)@" CMakeLists.txt
  '';

  cmakeFlags = with lib;
     optional enableDdc "-DENABLE_DDC=1"
  ++ optional enableDpms "-DENABLE_DPMS=1"
  ++ optional enableGamma "-DENABLE_GAMMA=1"
  ++ optional enableScreen "-DENABLE_SCREEN=1";

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
