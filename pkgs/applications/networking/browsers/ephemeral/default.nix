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
, wrapGAppsHook
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "ephemeral";
  version = "7.0.5";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ephemeral";
    rev = version;
    sha256 = "sha256-dets4YoTUgFCDOrvzNuAwJb3/MsnjOSBx9PBZuT0ruk=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
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
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "The always-incognito web browser";
    homepage = "https://github.com/cassidyjames/ephemeral";
    maintainers = with maintainers; [ xiorcale ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
