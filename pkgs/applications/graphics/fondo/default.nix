{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, vala
, pkg-config
, meson
, ninja
, python3
, glib
, gsettings-desktop-schemas
, gtk3
, libgee
, json-glib
, glib-networking
, libsoup
, libunity
, desktop-file-utils
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fondo";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "calo001";
    repo = pname;
    rev = version;
    sha256 = "sha256-EATZRmYSGUzWYaPqFT4mLTGGvwUp+Mn93yMF2JsPaYo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    libsoup
    libunity
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/calo001/fondo";
    description = "Find the most beautiful wallpapers for your desktop";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
  };

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };
}
