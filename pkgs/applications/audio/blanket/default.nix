{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, appstream-glib
, python3Packages
, glib
, gtk3
, libhandy
, gobject-introspection
, gst_all_1
}:

python3Packages.buildPythonApplication rec {
  pname = "blanket";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "blanket";
    rev = version;
    sha256 = "00i821zqfbigxmc709322r16z75qsw4rg23yhv35gza9sl65bzkg";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  # Broken with gobject-introspection setup hook
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;
  format = "other";

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    homepage = "https://github.com/rafaelmardojai/blanket";
    description = "Listen to different sounds";
    maintainers = with maintainers; [ onny ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
