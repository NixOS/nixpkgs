{ stdenv, fetchFromGitHub, fetchurl, gzip }:

stdenv.mkDerivation rec {
  name = "ndppd-${version}";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "DanielAdolfsson";
    repo = "ndppd";
    rev = "${version}";
    sha256 = "0niri5q9qyyyw5lmjpxk19pv3v4srjvmvyd5k6ks99mvqczjx9c0";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace /bin/gzip ${gzip}/bin/gzip
  '';

  postInstall = ''
    mkdir -p $out/etc
    cp ndppd.conf-dist $out/etc/ndppd.conf
  '';

  meta = {
    description = "A daemon that proxies NDP (Neighbor Discovery Protocol) messages between interfaces";
    homepage = https://github.com/DanielAdolfsson/ndppd;
    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
  };
}
