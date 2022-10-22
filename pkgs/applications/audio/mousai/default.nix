{ lib
, python3
, fetchFromGitHub
, substituteAll
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, librsvg
, meson
, ninja
, pkg-config
, pulseaudio
, wrapGAppsHook4
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mousai";
  version = "0.6.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    sha256 = "sha256-nCbFVFg+nVF8BOBfdzQVgdTRXR5UF18PJFC266yTFwg=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      pactl = "${lib.getBin pulseaudio}/bin/pactl";
    })
  ];

  postPatch = ''
    substituteInPlace build-aux/meson/postinstall.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache

    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    libadwaita
    librsvg
    pulseaudio
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    requests
  ];

  meta = with lib; {
    description = "Identify any songs in seconds";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
