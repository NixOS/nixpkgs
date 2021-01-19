{ lib, stdenv, fetchFromGitHub, pkg-config
, python3
, gsettings-desktop-schemas
, desktop-file-utils
, glib
, gtk3
, intltool
, libsoup
, json-glib
, wrapGAppsHook
, meson
, ninja
, vala
, sqlite
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:
let
  version = "7.3";

in stdenv.mkDerivation {
  pname = "gradio";
  inherit version;

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "gradio";
    rev = "v${version}";
    sha256 = "00982dynl36lpsrx3mkd2a479zsrc8jvwfb8i7pi6w7fzzd8n8bl";
  };

  nativeBuildInputs = [
    pkg-config

    meson
    ninja
    vala

    python3
  ];
  buildInputs = [
    sqlite

    glib
    intltool
    libsoup
    json-glib

    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    wrapGAppsHook
    desktop-file-utils
    gsettings-desktop-schemas
  ] ++ gst_plugins;

  enableParallelBuilding = true;
  postInstall = ''
    glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  patches = [ ./0001-Remove-post-install-script-that-hardcodes-paths.patch ];

  meta = with lib; {
    homepage = "https://github.com/haecker-felix/gradio";
    description = "A GTK3 app for finding and listening to internet radio stations";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.samdroid-apps ];
  };
}
