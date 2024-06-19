{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, desktop-file-utils
, vala
, gettext
, glib
, gtk3
, libgee
, libdazzle
, meson
, ninja
, pantheon
, pkg-config
, python3
, webkitgtk
, wrapGAppsHook3
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "ephemeral";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ephemeral";
    rev = version;
    sha256 = "sha256-07HO8nC2Pwz2EAea4ZzmqyMfQdgX8FVqDepdA6j/NT8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    gtk3
    libdazzle
    libgee
    pantheon.granite
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
    description = "The always-incognito web browser";
    homepage = "https://github.com/cassidyjames/ephemeral";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3;
    mainProgram = "com.github.cassidyjames.ephemeral";
  };
}
