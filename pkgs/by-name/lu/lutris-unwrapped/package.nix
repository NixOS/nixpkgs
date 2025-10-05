{
  python3Packages,
  lib,
  fetchFromGitHub,

  # build inputs
  atk,
  file,
  glib,
  gdk-pixbuf,
  glib-networking,
  gnome-desktop,
  gobject-introspection,
  gst_all_1,
  gtk3,
  libnotify,
  pango,
  webkitgtk_4_1,
  wrapGAppsHook3,
  meson,

  # check inputs
  xvfb-run,

  # commands that lutris needs
  xrandr,
  pciutils,
  psmisc,
  mesa-demos,
  vulkan-tools,
  pulseaudio,
  p7zip,
  xgamma,
  gettext,
  libstrangle,
  fluidsynth,
  xorgserver,
  xorg,
  util-linux,
  pkg-config,
  desktop-file-utils,
  appstream-glib,
}:

let
  # See lutris/util/linux.py
  requiredTools = [
    xrandr
    pciutils
    psmisc
    mesa-demos
    vulkan-tools
    pulseaudio
    p7zip
    xgamma
    libstrangle
    fluidsynth
    xorgserver
    xorg.setxkbmap
    xorg.xkbcomp
    # bypass mount suid wrapper which does not work in fhsenv
    util-linux
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "lutris-unwrapped";
  version = "0.5.19";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    hash = "sha256-CAXKnx5+60MITRM8enkYgFl5ZKM6HCXhCYNyG7kHhuQ=";
  };

  format = "other";

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    python3Packages.ninja
    wrapGAppsHook3
    pkg-config
  ];
  buildInputs = [
    atk
    gdk-pixbuf
    glib-networking
    gnome-desktop
    gtk3
    libnotify
    pango
    webkitgtk_4_1
  ]
  ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  # See `install_requires` in https://github.com/lutris/lutris/blob/master/setup.py
  dependencies = with python3Packages; [
    certifi
    dbus-python
    distro
    evdev
    lxml
    pillow
    pygobject3
    pypresence
    pyyaml
    requests
    protobuf
    moddb
  ];

  postPatch = ''
    substituteInPlace lutris/util/magic.py \
      --replace '"libmagic.so.1"' "'${lib.getLib file}/lib/libmagic.so.1'"
  '';

  # avoid double wrapping
  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath requiredTools}"
    "--prefix APPIMAGE_EXTRACT_AND_RUN : 1"
    "\${gappsWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      rapiteanu
      iedame
    ];
    platforms = platforms.linux;
    mainProgram = "lutris";
  };
}
