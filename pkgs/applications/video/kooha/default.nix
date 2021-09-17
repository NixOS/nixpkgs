{ lib, fetchFromGitHub, appstream-glib, desktop-file-utils, glib
, gobject-introspection, gst_all_1, gtk4, libadwaita, librsvg, meson, ninja
, pkg-config, python3, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec {
  pname = "kooha";
  version = "1.2.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    sha256 = "1qwbzdn0n1nxcfci1bhhkfchdhw5yz74fdvsa84cznyyx2jils8w";
  };

  buildInputs = [
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
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

  installCheckPhase = ''
    $out/bin/kooha --help
  '';

  meta = with lib; {
    description = "Simple screen recorder";
    homepage = "https://github.com/SeaDve/Kooha";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler ];
  };
}
