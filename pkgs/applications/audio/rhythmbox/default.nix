{ stdenv
, lib
, fetchurl
, fetchpatch
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
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:

stdenv.mkDerivation rec {
  pname = "rhythmbox";
  version = "3.4.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "l+u8YPN4sibaRbtEbYmQL26hgx4j8Q76ujZVk7HnTyo=";
  };

  patches = [
    # Fix stuff linking against rhythmdb not finding libxml headers
    # included by rhythmdb.h header.
    # https://gitlab.gnome.org/GNOME/rhythmbox/-/merge_requests/147
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/rhythmbox/-/commit/7e8c7b803a45b7badf350132f8e78e3d75b99a21.patch";
      sha256 = "5CE/NVlmx7FItNJCVQxx+x0DCYhUkAi/UuksfAiyWBg=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib
    itstool
    wrapGAppsHook
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

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

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
