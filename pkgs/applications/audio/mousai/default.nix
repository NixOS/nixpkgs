{ lib
, fetchurl
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

  src = fetchurl {
    url = "https://github.com/SeaDve/Mousai/archive/refs/tags/v${version}.tar.gz";
    sha256 = "1lzlrj1q2vcg6k9gilxj2b3z6d0iaqwn60iwi48v5blwjdaqr96v";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gobject-introspection
    python3
    desktop-file-utils
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

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Simple application for identifying songs";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
