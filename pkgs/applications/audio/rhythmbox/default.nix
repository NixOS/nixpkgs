{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, fetchFromGitLab
, python3
, vala
, glib
, gtk3
, libpeas
, libsoup
, libxml2
, libsecret
, libnotify
, libdmapsharing
, gnome
, gobject-introspection
, totem-pl-parser
, libgudev
, libgpod
, libmtp
, lirc
, brasero
, grilo
, tdb
, json-glib
, itstool
, wrapGAppsHook
, desktop-file-utils
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
, check
}:

stdenv.mkDerivation rec {
  pname = "rhythmbox";
  version = "3.4.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "+VaCEM5V5BHpKcj7leERohHb0ZzEf1ePKRxdMZtesDQ=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib
    itstool
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    python3
    libsoup
    libxml2
    tdb
    json-glib

    glib
    gtk3
    libpeas
    totem-pl-parser
    libgudev
    libgpod
    libmtp
    lirc
    brasero
    grilo

    gobject-introspection
    python3.pkgs.pygobject3

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    libdmapsharing # for daap support
    libsecret
    libnotify
  ] ++ gst_plugins;

  nativeCheckInputs = [
    check
  ];

  mesonFlags = [
    "-Dtests=disabled"
  ];

  # Requires DISPLAY
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "${python3.pkgs.pygobject3}/${python3.sitePackages}:$out/lib/rhythmbox/plugins/"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Rhythmbox";
    description = "A music playing application for GNOME";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
