{ lib, fetchFromGitHub, appstream-glib, desktop-file-utils, glib
, gobject-introspection, gst_all_1, gtk3, libhandy, librsvg, meson, ninja
, pkg-config, python3, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec {
  pname = "kooha";
  version = "1.1.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    sha256 = "05515xccs6y3wy28a6lkyn2jgi0fli53548l8qs73li8mdbxzd4c";
  };

  buildInputs = [
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libhandy
    librsvg
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    python3
    pkg-config
    wrapGAppsHook
  ];

  propagatedBuildInputs = [ python3.pkgs.pygobject3 ];

  strictDeps = false;

  buildPhase = ''
    export GST_PLUGIN_SYSTEM_PATH_1_0="$out/lib/gstreamer-1.0/:$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  # Fixes https://github.com/NixOS/nixpkgs/issues/31168
  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Simple screen recorder";
    homepage = "https://github.com/SeaDve/Kooha";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler ];
  };
}
