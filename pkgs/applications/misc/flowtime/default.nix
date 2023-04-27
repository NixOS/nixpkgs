{ stdenv
, lib
, fetchFromGitHub
, vala
, meson
, ninja
, wrapGAppsHook4
, libadwaita
, libxml2
, libgee
, gst_all_1
, gobject-introspection
, desktop-file-utils
, glib
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "flowtime";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "Diego-Ivan";
    repo = "Flowtime";
    rev = "v${version}";
    hash = "sha256-op643yU7KdkTO9hT0iYTIqBP4oPe0MT1R5I3FAtN0/I=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libxml2
    libgee
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
  ]);

  meta = with lib; {
    description = "Get what motivates you done, without losing concentration";
    homepage = "https://github.com/Diego-Ivan/Flowtime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
