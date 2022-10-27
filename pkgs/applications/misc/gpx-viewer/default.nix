{ lib, stdenv, fetchurl, intltool, libxml2, pkg-config, gnome, libchamplain, gdl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gpx-viewer";
  version = "0.4.0";

  src = fetchurl {
    url = "https://launchpad.net/gpx-viewer/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "956acfaf870ac436300cd9953dece630df7fd7dff8e4ae2577a6002884466f80";
  };

  patches = fetchurl {
    url = "https://code.launchpad.net/~chkr/gpx-viewer/gtk3-bugfix/+merge/260766/+preview-diff/628965/+files/preview.diff";
    sha256 = "1yl7jk7skkcx10nny5zdixswcymjd9s9c1zhm1i5y3aqhchvmfs7";
  };
  patchFlags = [ "-p0" ];

  configureFlags = [ "--disable-database-updates" ];

  nativeBuildInputs = [
    intltool pkg-config
    wrapGAppsHook # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
  ];
  buildInputs = [ gdl libchamplain gnome.adwaita-icon-theme libxml2 ];

  meta = with lib; {
    homepage = "https://blog.sarine.nl/tag/gpxviewer/";
    description = "Simple tool to visualize tracks and waypoints stored in a gpx file";
    platforms = with platforms; linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
