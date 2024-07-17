{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  itstool,
  wrapGAppsHook3,
  desktop-file-utils,
  libsoup,
  json-glib,
  geoclue2,
  geocode-glib,
  libgee,
  gtk3,
  pantheon,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "tuner";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "louis77";
    repo = pname;
    rev = version;
    sha256 = "sha256-tG1AMEqHcp4jHNgWDy9fS2FtlxFTlpMD5MVbepIY+GY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib
    itstool
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    libsoup
    json-glib
    geoclue2
    geocode-glib
    libgee
    glib
    gtk3
    pantheon.granite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
  ];

  meta = with lib; {
    homepage = "https://github.com/louis77/tuner";
    description = "App to discover and play internet radio stations";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "com.github.louis77.tuner";
    maintainers = [ maintainers.abbe ];
  };
}
