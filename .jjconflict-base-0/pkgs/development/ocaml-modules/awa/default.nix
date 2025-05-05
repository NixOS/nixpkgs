{
  lib,
  buildDunePackage,
  fetchurl,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-rng,
  mirage-crypto-pk,
  x509,
  cstruct,
  cstruct-unix,
  eqaf,
  mtime,
  logs,
  fmt,
  cmdliner,
  base64,
  zarith,
}:

buildDunePackage rec {
  pname = "awa";
  version = "0.5.0";

  minimalOCamlVersion = "4.10";

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${version}/awa-${version}.tbz";
    hash = "sha256-SYSkhB43KmYaCEYGwFihMPLvh1Zr9xeWFio5atY19A8=";
  };

  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-rng
    mirage-crypto-pk
    x509
    cstruct
    mtime
    logs
    base64
    zarith
    eqaf
  ];

  doCheck = true;
  checkInputs = [
    cstruct-unix
    cmdliner
    fmt
  ];

  meta = with lib; {
    description = "SSH implementation in OCaml";
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
