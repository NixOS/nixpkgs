{ lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, desktop-file-utils
, libhandy
, gst_all_1
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mousai";
  version = "0.2.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    sha256 = "10g3wj9yy15yzyfa1l96i97i3k6blm064p49hn7hp001cmc3w045";
  };

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gobject-introspection
    python3
    desktop-file-utils
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    libhandy
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    gst-python
    requests
  ];

  preFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Simple application for identifying songs";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
