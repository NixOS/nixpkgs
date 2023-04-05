{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2023-02-24";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "846be4e7fcddf45e66e0ff5b29fb5a212d6ee8c3";
    hash = "sha256-/j3VJRx/w9HQUnfoq/4gMWV5oVdRiPGddrgbCDk5y8c=";
  };

  nativeBuildInpts = [
    ppx_sexp_conv
    ppx_deriving
  ];

  buildInputs = [
    erm_xmpp
    tls
    mirage-crypto-pk
    x509
    domain-name
    lwt
    otr
    astring
    ptime
    notty
    sexplib
    hex
    uchar
    uucp
    uuseg
    uutf
    dns-client
    cstruct
    base64
    happy-eyeballs-lwt
  ];

  meta = with lib; {
    homepage = "https://github.com/hannesm/jackline";
    description = "minimalistic secure XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
