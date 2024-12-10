{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  whois,
  bind,
  mtr,
  jq,
  ipcalc,
  grepcidr,
  nmap,
  aha,
}:

stdenv.mkDerivation rec {
  pname = "asn";
  version = "0.76.1";

  src = fetchFromGitHub {
    owner = "nitefood";
    repo = "asn";
    rev = "refs/tags/v${version}";
    hash = "sha256-9UDd0tgRKEFC1V1+1s9Ghev0I48L8UR9/YbZKX3F1MU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -Dv asn "$out/bin/asn"

    wrapProgram $out/bin/asn \
      --prefix PATH : "${
        lib.makeBinPath [
          curl
          whois
          bind
          mtr
          jq
          ipcalc
          grepcidr
          nmap
          aha
        ]
      }"
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
