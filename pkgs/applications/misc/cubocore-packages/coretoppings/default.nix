{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  ffmpeg,
  cmake,
  ninja,
  v4l-utils,
  grim,
  wf-recorder,
  libdbusmenu,
  playerctl,
  xorg,
  iio-sensor-proxy,
  inotify-tools,
  bluez,
  networkmanager,
  connman,
  redshift,
  gawk,
  polkit,
  libnotify,
  systemd,
  xdg-utils,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coretoppings";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coretoppings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wHVdZqXn8DXqLbCdKz2fI8BjNVai5dRq3a45HVCvLa8=";
  };

  patches = [
    # Fix file cannot create directory: /var/empty/share/polkit-1/actions
    ./0001-fix-install-phase.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    libdbusmenu
    ffmpeg
    v4l-utils
    grim
    wf-recorder
    playerctl
    xorg.xrandr
    xorg.xinput
    xorg.libXdamage
    iio-sensor-proxy
    inotify-tools
    bluez
    networkmanager
    connman
    redshift
    gawk
    polkit
    libnotify
    systemd
    xdg-utils
    libcprime
    libcsys
  ];

  meta = {
    description = "Additional features,plugins etc for CuboCore Application Suite";
    mainProgram = "shareIT";
    homepage = "https://gitlab.com/cubocore/coreapps/coretoppings";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
