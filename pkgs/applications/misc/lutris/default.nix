{ buildPythonApplication, lib, fetchFromGitHub, fetchpatch
, wrapGAppsHook, gobject-introspection, glib-networking, gnome-desktop, libnotify, libgnome-keyring, pango
, gdk-pixbuf, atk, webkitgtk, gst_all_1
, dbus-python, evdev, pyyaml, pygobject3, requests, pillow
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
  pname = "lutris-original";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    sha256 = "1g093g0difnkjmnm91p20issdsxn9ri4c56zzddj5wfrbmhwdfag";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = [
    gobject-introspection glib-networking gnome-desktop libnotify libgnome-keyring pango
    gdk-pixbuf atk webkitgtk
  ] ++ gstDeps;

  makeWrapperArgs = [
    "--prefix PATH : ${binPath}"
  ];

  propagatedBuildInputs = [
    evdev pyyaml pygobject3 requests pillow dbus-python
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
