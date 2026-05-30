{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/f/firewalk/5.0-6/debian/patches/060_fix-ftbfs-gcc-15.patch";
      hash = "sha256-KEYHTSnUtNIGqm/uE2ZLV79KIWmofHeKVYdfTkpm4rI=";
    })
  ];

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
