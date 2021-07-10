{ lib, stdenv, fetchurl, pkg-config, fetchFromGitLab
, python3
, perl
, perlPackages
, gtk3
, intltool
, libpeas
, libsoup
, libdmapsharing
, gnome
, totem-pl-parser
, tdb
, json-glib
, itstool
, wrapGAppsHook
, gst_all_1
, gst_plugins ? with gst_all_1; [ gst-plugins-good gst-plugins-ugly ]
}:
let
  pname = "rhythmbox";
  version = "3.4.4";

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
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
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

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    libdmapsharing_3 # necessary for daap support
  ] ++ gst_plugins;

  configureFlags = [ "--enable-daap" ];

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
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
