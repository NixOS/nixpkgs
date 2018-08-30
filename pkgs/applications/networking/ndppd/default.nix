{ stdenv, fetchFromGitHub, fetchurl, gzip, ... }:

let
  serviceFile = fetchurl {
    url = "https://raw.githubusercontent.com/DanielAdolfsson/ndppd/f37e8eb33dc68b3385ecba9b36a5efd92755580f/ndppd.service";
    sha256 = "1zf54pzjfj9j9gr48075njqrgad4myd3dqmhvzxmjy4gjy9ixmyh";
  };
in stdenv.mkDerivation rec {
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

    mkdir -p $out/lib/systemd/system
    # service file needed for our module is not in release yet
    substitute ${serviceFile} $out/lib/systemd/system/ndppd.service \
      --replace /usr/sbin/ndppd $out/sbin/ndppd
  '';

  meta = {
    description = "A daemon that proxies NDP (Neighbor Discovery Protocol) messages between interfaces";
    homepage = https://github.com/DanielAdolfsson/ndppd;
    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
  };
}
