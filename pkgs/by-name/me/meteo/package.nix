{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  appstream,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  glib,
  glib-networking,
  gtk3,
  json-glib,
  libappindicator,
  libsoup_2_4,
  webkitgtk_4_0,
}:

stdenv.mkDerivation rec {
  pname = "meteo";
  version = "0.9.9.3";

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
    hash = "sha256-hubKusrs0Hh8RryoEI29pnhTSNsIbtGMltlH4qoM6gE=";
  };

  nativeBuildInputs = [
    appstream
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
    glib-networking # see #311066
    gtk3
    json-glib
    libappindicator
    libsoup_2_4
    webkitgtk_4_0
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Know the forecast of the next hours & days";
    homepage = "https://gitlab.com/bitseater/meteo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
    mainProgram = "com.gitlab.bitseater.meteo";
  };
}
