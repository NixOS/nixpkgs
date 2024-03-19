{ lib
, blueprint-compiler
, desktop-file-utils
, fetchFromGitHub
, gjs
, glib
, glib-networking
, gtk4
, libadwaita
, libportal
, libsecret
, libsoup_3
, meson
, ninja
, pkg-config
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "forge-sparks";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = pname;
    rev = version;
    hash = "sha256-kUvUAJLCqIQpjm8RzAZaHVkdDCD9uKSQz9cYN60xS+4=";
    fetchSubmodules = true;
  };

  patches = [
    # XdpGtk4 is imported but not used so we remove it to avoid the dependence on libportal-gtk4
    ./remove-xdpgtk4-import.patch
  ];

  postPatch = ''
    patchShebangs troll/gjspack/bin/gjspack
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gjs
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    libadwaita
    libportal
    libsecret
    libsoup_3
  ];

  meta = with lib; {
    description = "Get Git forges notifications";
    homepage = "https://github.com/rafaelmardojai/forge-sparks";
    changelog = "https://github.com/rafaelmardojai/forge-sparks/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ michaelgrahamevans ];
    mainProgram = "forge-sparks";
    platforms = platforms.linux;
  };
}
