{ stdenv, fetchurl, intltool, pkgconfig, gnome3, shared-mime-info, desktop-file-utils, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gpx-viewer-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://launchpad.net/gpx-viewer/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "956acfaf870ac436300cd9953dece630df7fd7dff8e4ae2577a6002884466f80";
  };

  patches = fetchurl {
    url = "https://code.launchpad.net/~chkr/gpx-viewer/gtk3-bugfix/+merge/260766/+preview-diff/628965/+files/preview.diff";
    sha256 = "1yl7jk7skkcx10nny5zdixswcymjd9s9c1zhm1i5y3aqhchvmfs7";
  };
  patchFlags = [ "-p0" ];

  nativeBuildInputs = [
    intltool pkgconfig
    shared-mime-info # For update-mime-database
    desktop-file-utils # For update-desktop-database
    wrapGAppsHook # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
  ];
  buildInputs = with gnome3; [ gdl libchamplain defaultIconTheme ];

  meta = with stdenv.lib; {
    homepage = https://blog.sarine.nl/tag/gpxviewer/;
    description = "Simple tool to visualize tracks and waypoints stored in a gpx file";
    platforms = with platforms; linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
