{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libestr,
  json_c,
  pcre,
  fastJson,
}:

stdenv.mkDerivation rec {
  pname = "liblognorm";
  version = "2.0.6";

  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/liblognorm-${version}.tar.gz";
    sha256 = "1wpn15c617r7lfm1z9d5aggmmi339s6yn4pdz698j0r2bkl5gw6g";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libestr
    json_c
    pcre
    fastJson
  ];

  configureFlags = [ "--enable-regexp" ];

  meta = with lib; {
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    homepage = "https://www.liblognorm.com/";
    license = licenses.lgpl21;
    mainProgram = "lognormalizer";
    platforms = platforms.all;
  };
}
