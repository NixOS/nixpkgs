{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libxml2,
  meson,
  ninja,
  vala,
  pkg-config,
  gnome,
  libchamplain,
  gdl,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gpx-viewer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "DaveDavenport";
    repo = "gpx-viewer";
    rev = version;
    hash = "sha256-6AChX0UEIrQExaq3oo9Be5Sr13+POHFph7pZegqcjio=";
  };

  patches = [
    # Compile with libchamplain>=0.12.21
    (fetchpatch {
      url = "https://github.com/DaveDavenport/gpx-viewer/commit/12ed6003bdad840586351bdb4e00c18719873c0e.patch";
      hash = "sha256-2/r0M3Yxj+vWgny1Pd5G7NYMb0uC/ByZ7y3tqLVccOc=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3 # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
  ];

  buildInputs = [
    gdl
    libchamplain
    gnome.adwaita-icon-theme
    libxml2
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://blog.sarine.nl/tag/gpxviewer/";
    description = "Simple tool to visualize tracks and waypoints stored in a gpx file";
    mainProgram = "gpx-viewer";
    changelog = "https://github.com/DaveDavenport/gpx-viewer/blob/${src.rev}/NEWS";
    platforms = with platforms; linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
