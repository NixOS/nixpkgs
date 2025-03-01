{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
  makeWrapper,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "arp-scan";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = "arp-scan";
    rev = version;
    sha256 = "sha256-BS+ItZd6cSMX92M6XGYrIeAiCB2iBdvbMvKdLfwawLQ=";
  };

  patches = [
    ./remove-install-exec-hook.patch
  ];

  perlModules = with perlPackages; [
    HTTPDate
    HTTPMessage
    LWP
    TextCSV
    URI
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];
  buildInputs = [
    perlPackages.perl
    libpcap
  ];

  postInstall = ''
    for binary in get-{oui,iab}; do
      wrapProgram "$out/bin/$binary" --set PERL5LIB "${perlPackages.makeFullPerlPath perlModules}"
    done;
  '';

  meta = with lib; {
    description = "ARP scanning and fingerprinting tool";
    longDescription = ''
      Arp-scan is a command-line tool that uses the ARP protocol to discover
      and fingerprint IP hosts on the local network.
    '';
    homepage = "https://github.com/royhills/arp-scan/wiki/arp-scan-User-Guide";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      bjornfor
      mikoim
      r-burns
    ];
    mainProgram = "arp-scan";
  };
}
