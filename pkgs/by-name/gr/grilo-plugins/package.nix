{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  gettext,
  gperf,
  glib,
  localsearch,
  sqlite,
  libarchive,
  libdmapsharing,
  libsoup_3,
  librest_1_0,
  gnome,
  libxml2,
  lua5_4,
  liboauth,
  libmediaart,
  grilo,
  gst_all_1,
  gnome-online-accounts,
  gmime,
  gom,
  json-glib,
  avahi,
  tinysparql,
  dleyna,
  itstool,
  totem-pl-parser,
}:

stdenv.mkDerivation rec {
  pname = "grilo-plugins";
  version = "0.3.18";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "jjznTucXw8Mi0MsPjfJrsJFAKKXQFuKAVf+0nMmkbF4=";
  };

  patches = [
    # grl-chromaprint requires the following GStreamer elements:
    # * fakesink (gstreamer)
    # * playbin (gst-plugins-base)
    # * chromaprint (gst-plugins-bad)
    (replaceVars ./chromaprint-gst-plugins.patch {
      load_plugins =
        lib.concatMapStrings
          (plugin: ''gst_registry_scan_path(gst_registry_get(), "${lib.getLib plugin}/lib/gstreamer-1.0");'')
          (
            with gst_all_1;
            [
              gstreamer
              gst-plugins-base
              gst-plugins-bad
            ]
          );
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    gperf # for lua-factory
    glib # glib-compile-resources
    localsearch
  ];

  buildInputs = [
    grilo
    libxml2
    # libgdata
    lua5_4
    liboauth
    sqlite
    gnome-online-accounts
    totem-pl-parser
    libarchive
    libdmapsharing
    libsoup_3
    librest_1_0
    gmime
    gom
    json-glib
    avahi
    libmediaart
    tinysparql
    dleyna
    gst_all_1.gstreamer
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/grilo-plugins";
    description = "Collection of plugins for the Grilo framework";
    teams = [ teams.gnome ];
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
