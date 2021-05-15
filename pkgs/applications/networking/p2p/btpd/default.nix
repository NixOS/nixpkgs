{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
}:

stdenv.mkDerivation rec {
  pname = "btpd";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "btpd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r8jml306jjfr0cpmgjv78kjln0pq899vj1v3pgnys2j6i3wq9s0";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "BitTorrent Protocol Daemon";
    longDescription = ''
      btpd is a utility for sharing files over the BitTorrent network protocol.
      It runs in daemon mode, thus needing no controlling terminal or GUI.
      Instead, the daemon is controlled by btcli, its command line utility, or
      other programs capable of sending commands and queries on the control socket.
    '';
    homepage = "https://github.com/btpd/btpd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
