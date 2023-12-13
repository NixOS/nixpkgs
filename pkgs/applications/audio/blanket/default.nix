{ lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, desktop-file-utils
, appstream-glib
, python3Packages
, glib
, gtk4
, libadwaita
, gobject-introspection
, gst_all_1
}:

python3Packages.buildPythonApplication rec {
  pname = "blanket";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "blanket";
    rev = "refs/tags/${version}";
    sha256 = "sha256-4gthT1x76IfXWkLaLMPtFS4TRlRGk5Enbu/k1jAHzwE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  format = "other";

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace build-aux/meson/postinstall.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache
  '';

  meta = with lib; {
    homepage = "https://github.com/rafaelmardojai/blanket";
    description = "Listen to different sounds";
    maintainers = with maintainers; [ onny ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
