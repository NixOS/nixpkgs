{ stdenv, fetchurl, pkgconfig
, python3
, perl
, perlPackages
, gtk3
, intltool
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
  version = "3.4.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0hzcns8gf5yb0rm4ss8jd8qzarcaplp5cylk6plwilsqfvxj4xn2";
  };

  patches = [
    # build with GStreamer 1.14 https://bugzilla.gnome.org/show_bug.cgi?id=788706
    (fetchurl {
      name = "fmradio-Fix-build-with-GStreamer-master.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=361178;
      sha256 = "1h09mimlglj9hcmc3pfp0d6c277mqh2khwv9fryk43pkv3904d2w";
    })
  ];

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
    gnome3.libpeas
    totem-pl-parser
    gnome3.defaultIconTheme

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
