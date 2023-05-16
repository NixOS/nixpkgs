{ lib
, stdenv
, fetchFromGitLab
, nix-update-script
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, glib
, gtk3
, json-glib
, libappindicator
, libsoup
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "meteo";
<<<<<<< HEAD
  version = "0.9.9.2";
=======
  version = "0.9.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "bitseater";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-9+FNpLjiX0zdsUnbBnNSLt/Ma/cqtclP25tl+faPlpU=";
=======
    sha256 = "sha256-kkUVTxh5svk61oDp/dpe3ILGyexYe3UaS+LgWsy+Z9s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    appstream
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
    gtk3
    json-glib
    libappindicator
    libsoup
    webkitgtk
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
