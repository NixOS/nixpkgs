{ stdenv, fetchurl, bash, utillinux, procps-ng, hostapd, iproute, iw,
haveged, dnsmasq, iptables }:

stdenv.mkDerivation rec {
  version = "0.1";
  name = "create_ap-${version}";

  src = fetchurl {
    url = "https://github.com/oblique/create_ap/archive/v${version}.tar.gz";
    sha256 = "0s8sf91pq9lpbj0w00v6lszgq2qc5xd9c1k4yaiyw4sqfx9x5hjx";
  };

  buildInputs = [ bash
                  utillinux
                  procps-ng
                  hostapd
                  iproute
                  iw
                  haveged
                  dnsmasq
                  iptables
                ];

  buildPhase = "";

  installPhase = ''
    mkdir $out/{bin,share/bash-completion/completions} -p
    cp create_ap $out/bin
  '';

  meta = {
    homepage = "https://github.com/oblique/create_ap";
    description = "creates a NATed or Bridged WiFi Access Point";
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
