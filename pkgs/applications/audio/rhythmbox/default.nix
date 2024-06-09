{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, python3
, vala
, glib
, gtk3
, libpeas
, libsoup_3
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
, wrapGAppsHook3
, desktop-file-utils
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
, check
}:

stdenv.mkDerivation rec {
  pname = "rhythmbox";
  version = "3.4.7";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "L21WwT/BpkxTT1AHiPtIKTbOVHs0PtkMZ94fK84M+n4=";
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
    gobject-introspection
  ];

  buildInputs = [
    python3
    libsoup_3
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
    "-Ddaap=enabled"
    "-Dtests=disabled"
  ];

  # Requires DISPLAY
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/lib/rhythmbox/plugins/"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/rhythmbox";
    description = "A music playing application for GNOME";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
