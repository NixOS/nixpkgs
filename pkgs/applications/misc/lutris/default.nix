{
  buildPythonApplication,
  lib,
  fetchFromGitHub,

  # build inputs
  atk,
  file,
  gdk-pixbuf,
  glib-networking,
  gnome-desktop,
  gobject-introspection,
  gst_all_1,
  gtk3,
  libnotify,
  pango,
  webkitgtk_4_0,
  wrapGAppsHook3,

  # check inputs
  xvfb-run,
  nose2,
  flake8,

  # python dependencies
  certifi,
  dbus-python,
  distro,
  evdev,
  lxml,
  pillow,
  pygobject3,
  pypresence,
  pyyaml,
  requests,
  protobuf,
  moddb,

  # commands that lutris needs
  xrandr,
  pciutils,
  psmisc,
  mesa-demos,
  vulkan-tools,
  pulseaudio,
  p7zip,
  xgamma,
  libstrangle,
  fluidsynth,
  xorgserver,
  xorg,
  util-linux,
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
buildPythonApplication rec {
  pname = "lutris-unwrapped";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    hash = "sha256-dI5hqWBWrOGYUEM9Mfm7bTh7BEc4e+T9gJeiZ3BiqmE=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs =
    [
      atk
      gdk-pixbuf
      glib-networking
      gnome-desktop
      gtk3
      libnotify
      pango
      webkitgtk_4_0
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
  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    xvfb-run
    nose2
    flake8
  ] ++ requiredTools;
  checkPhase = ''
    runHook preCheck

    export HOME=$PWD
    xvfb-run -s '-screen 0 800x600x24' make test

    runHook postCheck
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
      Madouura
      rapiteanu
    ];
    platforms = platforms.linux;
    mainProgram = "lutris";
  };
}
