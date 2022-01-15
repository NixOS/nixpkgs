{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, curl
, dht
, glib
, gtk3
, libb64
, libevent
, libgee
, libnatpmp
, libtransmission
, libutp
, miniupnpc
, openssl
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "torrential";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "davidmhewitt";
    repo = "torrential";
    rev = version;
    sha256 = "sha256-W9Is6l8y5XSlPER2BLlf+cyMPPdEQuaP4xM59VhfDE0=";
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
    curl
    dht
    glib
    gtk3
    libb64
    libevent
    libgee
    libnatpmp
    libtransmission
    libutp
    miniupnpc
    openssl
    pantheon.granite
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
    description = "Download torrents in style with this speedy, minimalist torrent client for elementary OS";
    homepage = "https://github.com/davidmhewitt/torrential";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "com.github.davidmhewitt.torrential";
  };
}
