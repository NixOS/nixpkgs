{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  extra-cmake-modules,
  gettext,
  libx11,
  libxrandr,
  libxxf86vm,
  libxrender,
  libxtst,
  libxcomposite,
  xwininfo,
  curl,
  wayland,
  wayland-scanner,
  python3,
  vala,
  gtk3,
  glib,
  cairo,
  librsvg,
  dbus,
  dbus-glib,
  libxml2,
  libGL,
  libGLU,
  wayland-protocols,
  json_c,
  gtk-layer-shell,
  libevdev,
  alsa-lib,
  libetpan,
  gnome-menus,
  libxklavier,
  gvfs,
  upower,
  zeitgeist,
  libexif,
  vte,
  lm_sensors,
  wget,
  libdbusmenu-gtk3,
  libical,
  libpulseaudio,
  webkitgtk_4_1,
  fftw,
  libayatana-indicator,
  ayatana-ido,

  x11Support ? true,
  waylandSupport ? true,
}:
stdenv.mkDerivation rec {
  pname = "cairo-dock";
  version = "3.6.2";

  srcCore = fetchFromGitHub {
    owner = "Cairo-Dock";
    repo = "cairo-dock-core";
    tag = version;
    hash = "sha256-csdqDyKLw3olwmDKwUOB37dJxGFcxhOLQoDHuHBsCbE=";
  };

  srcPlugins = fetchFromGitHub {
    owner = "Cairo-Dock";
    repo = "cairo-dock-plug-ins";
    tag = version;
    hash = "sha256-/nufMOsKVfQf5NOYc633QDODqrJpftExqhCqrlpvO+4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    vala
    python3
  ]
  ++ lib.optionals waylandSupport [
    extra-cmake-modules
    wayland-scanner
  ];

  NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/gio-unix-2.0" ];

  buildInputs = [
    # Core Libraries
    gtk3
    glib
    cairo
    librsvg
    dbus
    dbus-glib
    libxml2
    libGL
    libGLU
    curl
    gtk-layer-shell
    libevdev

    libx11
    libxrender
    libxtst
    libxcomposite
    libxrandr
    libxxf86vm
    libxklavier
  ]
  ++ [
    # TODO: choose plugins
    # Plugin Libraries
    alsa-lib
    libetpan
    gnome-menus
    gvfs
    upower
    zeitgeist
    libexif
    vte
    lm_sensors
    wget
    libdbusmenu-gtk3

    libical
    libpulseaudio
    webkitgtk_4_1
    fftw
    libayatana-indicator
    ayatana-ido
  ]
  ++ lib.optionals x11Support [
    xwininfo
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    json_c
    gtk-layer-shell
    libevdev
  ];

  unpackPhase = ''
    cp -R ${srcCore} core
    cp -R ${srcPlugins} plugins
    chmod -R u+w core plugins
  '';

  configurePhase = ''
    mkdir -p core/build plugins/build

    cd core/build
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_BUILD_TYPE=Release \
      -Denable-desktop-manager=True \
      -Denable-egl-support=True \
      -Denable-x11-support=${if x11Support then "True" else "False"} \
      -Denable-wayland-support=${if waylandSupport then "True" else "False"} \
      -Denable-gtk-layer-shell=${if waylandSupport then "True" else "False"} \
      -Denable-wayland-protocols=${if waylandSupport then "True" else "False"} \
      -Dplugins-prefix=$out
    cd ../..
  '';

  buildPhase = ''
    echo "Building core..."
    make -C core/build -j$NIX_BUILD_CORES

    echo "Installing core to $out to satisfy plugin dependencies..."
    make -C core/build install

    echo "Configuring plugins..."
    cd plugins/build

    export PKG_CONFIG_PATH="$out/lib/pkgconfig:$PKG_CONFIG_PATH"

    cmake .. \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_PREFIX_PATH=$out \
      -DCMAKE_BUILD_TYPE=Release

    echo "Building plugins..."
    make -j$NIX_BUILD_CORES
    cd ../..
  '';

  installPhase = ''
    echo "Installing plugins to $out..."
    # move plugins to appropriate place
    make -C plugins/build install
  '';

  meta = {
    description = "A pretty, light and convenient interface to your GNU/Linux and BSD desktop, able to replace advantageously your system panel";
    homepage = "https://github.com/Cairo-Dock"; # glx-dock.org seems to be down
    maintainers = with lib.maintainers; [ hideyosh1 ];
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
