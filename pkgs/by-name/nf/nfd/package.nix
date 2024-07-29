{
  lib,
  stdenv,
  boost ? ndn-cxx.boost,
  fetchFromGitHub,
  libpcap,
  ndn-cxx,
  openssl,
  pkg-config,
  sphinx,
  systemd,
  wafHook,
  websocketpp,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  withWebSocket ? true,
}:

stdenv.mkDerivation rec {
  pname = "nfd";
  version = "24.07";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "NFD";
    rev = "NFD-${version}";
    hash = "sha256-HbKPO3gwQWOZf4QZE+N7tAiqsNl1GrcwE4EUGjWmf5s=";
  };

  nativeBuildInputs = [
    pkg-config
    sphinx
    wafHook
  ];
  buildInputs = [
    libpcap
    ndn-cxx
    openssl
    websocketpp
  ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) Forwarding Daemon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
