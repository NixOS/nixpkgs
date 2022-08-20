{ buildPythonApplication
, lib
, fetchFromGitHub

  # build inputs
, atk
, file
, gdk-pixbuf
, glib-networking
, gnome-desktop
, gobject-introspection
, gst_all_1
, gtk3
, libnotify
, pango
, webkitgtk
, wrapGAppsHook

  # check inputs
, xvfb-run
, nose2
, flake8

  # python dependencies
, dbus-python
, distro
, evdev
, lxml
, pillow
, pygobject3
, pyyaml
, requests
, keyring
, python-magic

  # commands that lutris needs
, xrandr
, pciutils
, psmisc
, glxinfo
, vulkan-tools
, xboxdrv
, pulseaudio
, p7zip
, xgamma
, libstrangle
, wine
, fluidsynth
, xorgserver
, xorg
}:

let
  # See lutris/util/linux.py
  requiredTools = [
    xrandr
    pciutils
    psmisc
    glxinfo
    vulkan-tools
    xboxdrv
    pulseaudio
    p7zip
    xgamma
    libstrangle
    wine
    fluidsynth
    xorgserver
    xorg.setxkbmap
    xorg.xkbcomp
  ];

  binPath = lib.makeBinPath requiredTools;

  gstDeps = with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ];

in
buildPythonApplication rec {
  pname = "lutris-original";
  version = "0.5.10.1";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Bf8UEGEM6M4PKoX/qKQNb9XxrxLcjKZD1vR3R2/PykI=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [
    atk
    gdk-pixbuf
    glib-networking
    gnome-desktop
    gobject-introspection
    gtk3
    libnotify
    pango
    webkitgtk
    python-magic
  ] ++ gstDeps;

  propagatedBuildInputs = [
    evdev
    distro
    lxml
    pyyaml
    pygobject3
    requests
    pillow
    dbus-python
    keyring
    python-magic
  ];

  postPatch = ''
    substituteInPlace lutris/util/magic.py \
      --replace "'libmagic.so.1'" "'${lib.getLib file}/lib/libmagic.so.1'"
  '';


  checkInputs = [ xvfb-run nose2 flake8 ] ++ requiredTools;
  preCheck = "export HOME=$PWD";
  checkPhase = ''
    runHook preCheck
    xvfb-run -s '-screen 0 800x600x24' make test
    runHook postCheck
  '';

  # avoid double wrapping
  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix PATH : ${binPath}"
    "\${gappsWrapperArgs[@]}"
  ];
  # needed for glib-schemas to work correctly (will crash on dialogues otherwise)
  # see https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  meta = with lib; {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
}
