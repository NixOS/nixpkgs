{
  lib,
  stdenv,
  buildDunePackage,
  fetchurl,
  cstruct,
  duration,
  ethernet,
  ipaddr,
  logs,
  lwt,
  macaddr,
  mirage-sleep,
  alcotest,
  bos,
  mirage-vnetif,
}:

buildDunePackage rec {
  pname = "arp";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-C2Bh/2NwZqCJEidCnkhwRMoW3AsbQtvwdFh9IiJkDaU=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cstruct
    duration
    ethernet
    ipaddr
    logs
    lwt
    macaddr
    mirage-sleep
  ];

  ## NOTE: As of 18 april 2023 and ARP version 3.0.0, tests fail on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkInputs = [
    alcotest
    bos
    mirage-vnetif
  ];

  meta = with lib; {
    description = "Address Resolution Protocol purely in OCaml";
    homepage = "https://github.com/mirage/arp";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
