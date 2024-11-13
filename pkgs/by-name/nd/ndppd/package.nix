{ lib, stdenv, fetchFromGitHub, gzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "ndppd";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "DanielAdolfsson";
    repo = "ndppd";
    rev = version;
    hash = "sha256-FqOoN7MxewmOxd4SKnOx4W/c3X4Jso/kFdiTzIRqHaw=";
  };

  nativeBuildInputs = [ gzip ];

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
