{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nat-traverse";
  version = "0.7";

  src = fetchurl {
    url = "https://www.speicherleck.de/iblech/nat-traverse/nat-traverse-${finalAttrs.version}.tar.bz2";
    sha256 = "0knwnqsjwv7sa5wjb863ghabs7s269a73qwkmxpsbngjw9s0j2ih";
  };

  nativeBuildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp nat-traverse $out/bin
    gzip -c nat-traverse.1 > $out/share/man/man1/nat-traverse.1.gz
  '';

  meta = {
    description = "NAT gateway traversal utility";
    longDescription = ''
      nat-traverse establishes direct connections between nodes which are
      behind NAT gateways, i.e. hosts which do not have public IP addresses.
      This is done using an UDP NAT traversal technique. Additionally, it's
      possible to setup a small VPN by using pppd on top of nat-traverse.

      nat-traverse does not need an external server on the Internet, and it
      isn't necessary to reconfigure the involved NAT gateways, either.
      nat-traverse works out-of-the-box.
    '';
    homepage = "https://www.speicherleck.de/iblech/nat-traverse/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.iblech ];
    mainProgram = "nat-traverse";
  };
})
