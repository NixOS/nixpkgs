{ buildPythonApplication, lib, fetchFromGitHub, fetchpatch

# build inputs
, atk
, gdk-pixbuf
, glib-networking
, gnome-desktop
, gobject-introspection
, gst_all_1
, gtk3
, libgnome-keyring
, libnotify
, pango
, webkitgtk
, wrapGAppsHook

# python dependencies
, dbus-python
, distro
, evdev
, pillow
, pygobject3
, pyyaml
, requests

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
  binPath = lib.makeBinPath [
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

  gstDeps = with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ];

in buildPythonApplication rec {
  pname = "lutris-original";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    sha256 = "1f78qhyy8xqdg0rhxcwkap1bmg5mfxhb8qw1vbpxr6g62ajpwksa";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [
    atk
    gdk-pixbuf
    glib-networking
    gnome-desktop
    gobject-introspection
    gtk3
    libgnome-keyring
    libnotify
    pango
    webkitgtk
  ] ++ gstDeps;

  propagatedBuildInputs = [
    evdev distro pyyaml pygobject3 requests pillow dbus-python
  ];

  # avoid double wrapping
  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix PATH : ${binPath}"
    ''''${gappsWrapperArgs[@]}''
  ];
  # needed for glib-schemas to work correctly (will crash on dialogues otherwise)
  # see https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  preCheck = "export HOME=$PWD";

  meta = with lib; {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.linux;
  };
}
