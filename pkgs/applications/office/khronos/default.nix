{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkg-config
, desktop-file-utils
, pantheon
, python3
, glib
, gtk4
, json-glib
, libadwaita
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "khronos";
  version = "3.5.9";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "sha256-3FatmyANB/tNYSN2hu5IVkyCy0YrC3uA2d/3+5u48w8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Track each task's time in a simple inobtrusive way";
    homepage = "https://github.com/lainsce/khronos";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
