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
, libportal-gtk4
, blueprint-compiler
}:

stdenv.mkDerivation rec {
  pname = "flowtime";
  version = "6.1";

  src = fetchFromGitHub {
    owner = "Diego-Ivan";
    repo = "Flowtime";
    rev = "v${version}";
    hash = "sha256-wTqHTkt1O3Da2fzxf6DiQjrqOt65ZEhLOkGK5C6HzIk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
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
    libportal-gtk4
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
  ]);

  meta = with lib; {
    description = "Get what motivates you done, without losing concentration";
    homepage = "https://github.com/Diego-Ivan/Flowtime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared pokon548 ];
  };
}
