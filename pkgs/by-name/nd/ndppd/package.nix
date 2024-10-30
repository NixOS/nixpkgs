{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "ndppd";
  version = "0.2.5.43";

  src = fetchurl {
    url = "https://api.opensuse.org/public/source/network/ndppd/ndppd-${version}.tar.xz";
    hash = "sha256-KhU5WefVaWfHM62zY3m7VryLeN9g2u8vCqyqkVM5jRs";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace-fail /bin/gzip gzip
    substituteInPlace src/ndppd.h --replace-fail "0.2.4" "${version}"
  '';

  postInstall = ''
    mkdir -p $out/etc
    cp ndppd.conf-dist $out/etc/ndppd.conf
  '';

  passthru.tests = { inherit (nixosTests) ndppd; };

  meta = with lib; {
    description = "Daemon that proxies NDP (Neighbor Discovery Protocol) messages between interfaces";
    homepage = "https://github.com/DanielAdolfsson/ndppd";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fadenb ];
    mainProgram = "ndppd";
  };
}
