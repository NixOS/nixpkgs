{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2021-04-23";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "861c59bb7cd27ad5c7558ff94cb0d0e8dca249e5";
    sha256 = "00waw5qr0n70i9l9b25r9ryfi836x4qrj046bb4k9qa4d0p8q1sa";
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
    ocaml_lwt
    otr
    astring
    ptime
    notty
    sexplib
    hex
    uutf
    uchar
    uuseg
    uucp
    dns-client
    cstruct
    base64
  ];

  meta = with lib; {
    homepage = "https://github.com/hannesm/jackline";
    description = "minimalistic secure XMPP client in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
