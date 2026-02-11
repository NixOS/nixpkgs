{
  lib,
  stdenv,
  fetchurl,
  libnet,
  libpcap,
  libdnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "firewalk";
  version = "5.0";

  src = fetchurl {
    url = "https://salsa.debian.org/pkg-security-team/firewalk/-/archive/upstream/${finalAttrs.version}/firewalk-upstream-${finalAttrs.version}.tar.gz";
    hash = "sha256-f0sHzcH3faeg7epfpWXbgaHrRWaWBKMEqLdy38+svGo=";
  };

  buildInputs = [
    libnet
    libpcap
    libdnet
  ];

  meta = {
    description = "Gateway ACL scanner";
    mainProgram = "firewalk";
    homepage = "http://packetfactory.openwall.net/projects/firewalk/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tochiaha ];
    platforms = lib.platforms.linux;
  };
})
