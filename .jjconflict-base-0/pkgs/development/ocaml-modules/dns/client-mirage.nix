{
  buildDunePackage,
  dns,
  dns-client,
  lwt,
  mirage-sleep,
  mirage-mtime,
  mirage-ptime,
  mirage-crypto-rng,
  domain-name,
  ipaddr,
  ca-certs-nss,
  happy-eyeballs,
  happy-eyeballs-mirage,
  tcpip,
  tls-mirage,
}:

buildDunePackage {
  pname = "dns-client-mirage";
  inherit (dns) src version;

  propagatedBuildInputs = [
    dns-client
    domain-name
    ipaddr
    lwt
    mirage-crypto-rng
    mirage-sleep
    mirage-mtime
    mirage-ptime
    ca-certs-nss
    happy-eyeballs
    happy-eyeballs-mirage
    tcpip
    tls-mirage
  ];
  doCheck = true;

  meta = dns-client.meta;
}
