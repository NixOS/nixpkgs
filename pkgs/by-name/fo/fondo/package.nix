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
, libhandy
, libsoup_2_4
, json-glib
, glib-networking
, desktop-file-utils
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "fondo";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "calo001";
    repo = pname;
    rev = version;
    sha256 = "sha256-JiDbkVs+EZRWRohSiuh8xFFgEhbnMYZfnZtz5Z4Wdb0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    libhandy
    libsoup_2_4
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/calo001/fondo";
    description = "Find the most beautiful wallpapers for your desktop";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.calo001.fondo";
  };
}
