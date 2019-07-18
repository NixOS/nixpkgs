{ buildPythonApplication, lib, fetchFromGitHub
, wrapGAppsHook, gobject-introspection, gnome-desktop, libnotify, libgnome-keyring, pango
, gdk_pixbuf, atk, webkitgtk, gst_all_1
, evdev, pyyaml, pygobject3, requests, pillow
, xrandr, pciutils, psmisc, glxinfo, vulkan-tools, xboxdrv, pulseaudio, p7zip, xgamma
, libstrangle, wine, fluidsynth, xorgserver
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
  ];

  gstDeps = with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
    gst-libav
  ];

in buildPythonApplication rec {
  name = "lutris-original-${version}";
  version = "0.5.2.1";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    sha256 = "023yqnzmnkfpq21r6ky6jzwbjxjcw1a5zqrrdl6fwwlr78fdhgpv";
  };

  buildInputs = [
    wrapGAppsHook gobject-introspection gnome-desktop libnotify libgnome-keyring pango
    gdk_pixbuf atk webkitgtk
  ] ++ gstDeps;

  makeWrapperArgs = [
    "--prefix PATH : ${binPath}"
  ];

  propagatedBuildInputs = [
    evdev pyyaml pygobject3 requests pillow
  ];

  preCheck = "export HOME=$PWD";

  meta = with lib; {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.linux;
  };
}

