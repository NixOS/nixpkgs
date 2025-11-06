{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.4";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    hash = "sha256-vjIHcfB15H3X5XBLSF6b3H3REQeIQ0XA98GHSTV/Zo0=";
  };

  configureFlags = [
    "--enable-ipv6"
    "--enable-ipv4"
  ];

  meta = {
    description = "Send ICMP echo probes to network hosts";
    homepage = "http://fping.org/";
    changelog = "https://github.com/schweikert/fping/releases/tag/v${version}";
    license = lib.licenses.bsd0;
    mainProgram = "fping";
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
}
