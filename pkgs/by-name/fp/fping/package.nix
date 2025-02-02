{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.2";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    hash = "sha256-p2ktENc/sLt24fdFmqfxm7zb/Frb7e8C9GiXSxiw5C8=";
  };

  configureFlags = [
    "--enable-ipv6"
    "--enable-ipv4"
  ];

  meta = with lib; {
    description = "Send ICMP echo probes to network hosts";
    homepage = "http://fping.org/";
    changelog = "https://github.com/schweikert/fping/releases/tag/v${version}";
    license = licenses.bsd0;
    mainProgram = "fping";
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
