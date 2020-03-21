{ buildPythonApplication, lib, fetchFromGitHub, fetchpatch
, wrapGAppsHook, gobject-introspection, gnome-desktop, libnotify, libgnome-keyring, pango
, gdk-pixbuf, atk, webkitgtk, gst_all_1
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
  pname = "lutris-original";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    rev = "v${version}";
    sha256 = "0i4i6g3pys1vf2q1pbs1fkywgapj4qfxrjrvim98hzw9al4l06y9";
  };

  patches = [(
    fetchpatch {
      url = "https://github.com/lutris/lutris/pull/2558.patch";
      sha256 = "1wbsplri5ii06gzv6mzhiic61zkgsp9bkjkaknkd83203p0i9b2d";
    }
  )];

  buildInputs = [
    wrapGAppsHook gobject-introspection gnome-desktop libnotify libgnome-keyring pango
    gdk-pixbuf atk webkitgtk
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
