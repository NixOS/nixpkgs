{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, curl
, whois
, bind
, mtr
, jq
, ipcalc
, grepcidr
, nmap
, aha
}:

stdenv.mkDerivation rec {
  pname = "asn";
  version = "0.76.0";

  src = fetchFromGitHub {
    owner = "nitefood";
    repo = "asn";
    rev = "refs/tags/v${version}";
    hash = "sha256-pdtRf9VKEdNg1UeYSaLNLm9O057dT+n5g3Dd0bcP4EI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -Dv asn "$out/bin/asn"

    wrapProgram $out/bin/asn \
      --prefix PATH : "${lib.makeBinPath [ curl whois bind mtr jq ipcalc grepcidr nmap aha ]}"
  '';

  meta = with lib; {
    description = "OSINT command line tool for investigating network data";
    longDescription = ''
      ASN / RPKI validity / BGP stats / IPv4v6 / Prefix / URL / ASPath / Organization /
      IP reputation / IP geolocation / IP fingerprinting / Network recon /
      lookup API server / Web traceroute server
    '';
    homepage = "https://github.com/nitefood/asn";
    changelog = "https://github.com/nitefood/asn/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ devhell ];
    mainProgram = "asn";
  };
}
