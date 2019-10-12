{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, vala
, pantheon
, curl
, glib
, gtk3
, hicolor-icon-theme
, libb64
, libevent
, libgee
, libnatpmp
, libunity
, miniupnpc
, openssl
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "torrential";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "davidmhewitt";
    repo = "torrential";
    rev = version;
    fetchSubmodules = true;
    sha256 = "17aby0c17ybyzyzyc1cg1j6q1a186801fy84avlaxahqp7vdammx";
  };

  nativeBuildInputs = [
    cmake
    vala
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    curl
    glib
    gtk3
    hicolor-icon-theme
    libb64
    libevent
    libgee
    libnatpmp
    libunity
    miniupnpc
    openssl
    pantheon.granite
  ];

  meta = with stdenv.lib; {
    description = "Download torrents in style with this speedy, minimalist torrent client for elementary OS";
    homepage = https://github.com/davidmhewitt/torrential;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
