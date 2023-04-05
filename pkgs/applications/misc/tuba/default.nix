{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, python3
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, gtk4
, libadwaita
, json-glib
, glib
, glib-networking
, libxml2
, libgee
, libsoup
, libsecret
, gst_all_1
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "tuba";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Tuba";
    rev = "v${version}";
    hash = "sha256-dkURVzbDBrE4bBUvf2fPqvgLKE07tn7jl3OudZpEWUo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    python3
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib
    glib-networking
    json-glib
    libxml2
    libgee
    libsoup
    gtk4
    libadwaita
    libsecret
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  passthru = {
    updateScript = nix-update-script {
      attrPath = "tuba";
    };
  };

  meta = with lib; {
    description = "Browse the Fediverse";
    homepage = "https://tuba.geopjr.dev/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
