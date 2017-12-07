{ stdenv, fetchFromGitHub, pkgconfig
, gcc
, python3
, gsettings_desktop_schemas
, desktop_file_utils
, glib
, gtk3
, intltool
, libsoup
, json_glib
, wrapGAppsHook
, meson
, ninja
, vala
, sqlite
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:
let
  version = "6.0.2";

in stdenv.mkDerivation rec {
  name = "gradio-${version}";

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "gradio";
    rev = "v${version}";
    sha256 = "05hg26yr7splgpkl8wjxcsdks9sm1is3hcnp7f5mjnp2ch0nn57s";
  };

  nativeBuildInputs = [
    pkgconfig

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
    json_glib

    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    wrapGAppsHook
    desktop_file_utils
    gsettings_desktop_schemas
  ] ++ gst_plugins;

  enableParallelBuilding = true;
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  patches = [ ./0001-Remove-post-install-script-that-hardcodes-paths.patch ];

  meta = with stdenv.lib; {
    homepage = https://github.com/haecker-felix/gradio;
    description = "A GTK3 app for finding and listening to internet radio stations";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.samdroid-apps ];
  };
}
