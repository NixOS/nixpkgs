{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  protobuf_21,
  openssl,
  libpcap,
  traceroute,
  withGUI ? false,
  qt5,
}:

let
  inherit (lib) optional;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "spoofer";
  version = "1.5.0";

  src = fetchurl {
    url = "https://www.caida.org/projects/spoofer/downloads/spoofer-${finalAttrs.version}.tar.gz";
    hash = "sha256-uWQcfKAs8Ho8Zh+67exRVJOyM9i+sgu/7t8vuVWGyIU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    protobuf_21
    libpcap
    traceroute
  ]
  ++ optional withGUI qt5.qtbase;

  dontWrapQtApps = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.caida.org/projects/spoofer";
    description = "Assess and report on deployment of source address validation";
    longDescription = ''
      Spoofer is a new client-server system for Windows, MacOS, and
      UNIX-like systems that periodically tests a network's ability to
      both send and receive packets with forged source IP addresses
      (spoofed packets). This can be used to produce reports and
      visualizations to inform operators, response teams, and policy
      analysts. The system measures different types of forged
      addresses, including private and neighboring addresses.  The
      test results allows to analyze characteristics of networks
      deploying source address validation (e.g., network location,
      business type).
    '';
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    mainProgram = "spoofer-prober";
  };
})
