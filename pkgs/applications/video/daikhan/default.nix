{ pkgs
, lib
, stdenv
, callPackage
, fetchFromGitLab
, vala
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gtk4
, libadwaita
, gst_all_1
, xxHash
, desktop-file-utils
, appstream
, appstream-glib
, blueprint-compiler
}:

stdenv.mkDerivation rec {
  pname = "daikhan";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "daikhan";
    repo = "daikhan";
    rev = "47522bf4f91a5c0d1770381c2b94023aef078a85";
    hash = "sha256-IPRIJsvPMwA/YYiVwBPk73IE1Z/9hLgh20lIvp4DJVo=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream
    desktop-file-utils
    appstream-glib
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    xxHash
  ] ++ (with gst_all_1; [ 
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gstreamer
      gst-plugins-rs
    ]);

  meta = with lib; {
    description = "A media player for the modern desktop";
    homepage = "https://gitlab.com/daikhan/daikhan";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sund3RRR ];
  };
}