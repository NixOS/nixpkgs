{ lib, stdenv, fetchurl, pkg-config, fetchFromGitLab
, python3
, perl
, perlPackages
, gtk3
, intltool
, libpeas
, libsoup
, libsecret
, libnotify
, libdmapsharing
, gnome
, gobject-introspection
, totem-pl-parser
, tdb
, json-glib
, itstool
, wrapGAppsHook
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:
let

  # The API version of libdmapsharing required by rhythmbox 3.4.4 is 3.0.

  # This PR would solve the issue:
  # https://gitlab.gnome.org/GNOME/rhythmbox/-/merge_requests/12
  # Unfortunately applying this patch produces a rhythmbox which
  # cannot fetch data from DAAP shares.

  libdmapsharing_3 = libdmapsharing.overrideAttrs (old: rec {
    version = "2.9.41";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = old.pname;
      rev = "${lib.toUpper old.pname}_${lib.replaceStrings ["."] ["_"] version}";
      sha256 = "05kvrzf0cp3mskdy6iv7zqq24qdczl800q2dn1h4bk3d9wchgm4p";
    };
  });

in stdenv.mkDerivation rec {
  pname = "rhythmbox";
  version = "3.4.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "142xcvw4l19jyr5i72nbnrihs953pvrrzcbijjn9dxmxszbv03pf";
  };

  nativeBuildInputs = [
    pkg-config
    intltool perl perlPackages.XMLParser
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    python3
    libsoup
    tdb
    json-glib

    gtk3
    libpeas
    totem-pl-parser
    gnome.adwaita-icon-theme

    gobject-introspection
    python3.pkgs.pygobject3

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    libdmapsharing_3 # necessary for daap support
    libsecret
    libnotify
  ] ++ gst_plugins;

  configureFlags = [
    "--enable-daap"
    "--enable-libnotify"
    "--with-libsecret"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "${python3.pkgs.pygobject3}/${python3.sitePackages}:$out/lib/rhythmbox/plugins/"
    )
  '';

  enableParallelBuilding = true;

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
