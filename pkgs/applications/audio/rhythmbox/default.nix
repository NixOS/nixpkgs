{ stdenv, fetchurl, pkgconfig
, python3
, perl
, perlPackages
, gtk3
, intltool
, libpeas
, libsoup
, gnome3
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
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "142xcvw4l19jyr5i72nbnrihs953pvrrzcbijjn9dxmxszbv03pf";
  };

  nativeBuildInputs = [
    pkgconfig
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
    gnome3.adwaita-icon-theme

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ] ++ gst_plugins;

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Rhythmbox;
    description = "A music playing application for GNOME";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
