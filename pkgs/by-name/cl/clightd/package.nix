{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  cmake,
  pkg-config,
  wayland-scanner,
  glib,
  udev,
  polkit,
  libusb1,
  libjpeg,
  libmodule,
  libXdmcp,
  util-linux,
  libpthreadstubs,
  enableDdc ? true,
  ddcutil,
  enableDpms ? true,
  libXext,
  enableGamma ? true,
  libdrm,
  libXrandr,
  libiio,
  wayland,
  enableScreen ? true,
  enableYoctolight ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clightd";
  version = "5.9";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "Clightd";
    tag = finalAttrs.version;
    hash = "sha256-LOhBBd7QL5kH4TzMFgrh70C37WsFdsiKArP+tIEiPWo=";
  };

  # dbus-1.pc has datadir=/etc
  SYSTEM_BUS_DIR = "${placeholder "out"}/share/dbus-1/system-services";
  # polkit-gobject-1.pc has prefix=${polkit.out}
  POLKIT_ACTION_DIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    sed -i "s@pkg_get_variable(SYSTEM_BUS_DIR.*@set(SYSTEM_BUS_DIR $SYSTEM_BUS_DIR)@" CMakeLists.txt
    sed -i "s@pkg_get_variable(POLKIT_ACTION_DIR.*@set(POLKIT_ACTION_DIR $POLKIT_ACTION_DIR)@" CMakeLists.txt
  '';

  cmakeFlags = [
    "-DSYSTEMD_SERVICE_DIR=${placeholder "out"}/lib/systemd/system"
    "-DDBUS_CONFIG_DIR=${placeholder "out"}/etc/dbus-1/system.d"
    # systemd.pc has prefix=${systemd.out}
    "-DMODULE_LOAD_DIR=${placeholder "out"}/lib/modules-load.d"
  ]
  ++ lib.optional enableDdc "-DENABLE_DDC=1"
  ++ lib.optional enableDpms "-DENABLE_DPMS=1"
  ++ lib.optional enableGamma "-DENABLE_GAMMA=1"
  ++ lib.optional enableScreen "-DENABLE_SCREEN=1"
  ++ lib.optional enableYoctolight "-DENABLE_YOCTOLIGHT=1";

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    dbus
    glib
    udev
    polkit
    libusb1
    libjpeg
    libmodule
    libiio

    libXdmcp
    util-linux
    libpthreadstubs
  ]
  ++ lib.optionals enableDdc [ ddcutil ]
  ++ lib.optionals enableDpms [ libXext ]
  ++ lib.optionals enableGamma [ libXrandr ]
  ++ lib.optionals (enableDpms || enableGamma || enableScreen) [
    libdrm
    wayland
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -svT $out/libexec/clightd $out/bin/clightd
  '';

  meta = {
    description = "Linux bus interface that changes screen brightness/temperature";
    mainProgram = "clightd";
    homepage = "https://github.com/FedeDP/Clightd";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      eadwu
    ];
  };
})
