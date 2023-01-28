{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2022-05-27";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "d8f7c504027a0dd51966b2b7304d6daad155a05b";
    hash = "sha256-6SWYl2mB0g8JNVHBeTnZEbzOaTmVbsRMMEs+3j/ewwk=";
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
