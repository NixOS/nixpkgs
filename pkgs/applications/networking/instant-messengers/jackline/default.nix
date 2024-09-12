{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2024-02-28";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev  = "31b90275a5f848cfc8c4f5b75e7d1933bec37852";
    hash = "sha256-G2jjsc/i9Qgo0TP+ZE4gB/1cjuZ9l8R7e59K2DGD5GY=";
  };

  nativeBuildInpts = [
    ppx_sexp_conv
    ppx_deriving
  ];

  buildInputs = [
    erm_xmpp
    tls
    tls-lwt
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
    ppx_sexp_conv
  ];

  meta = with lib; {
    homepage = "https://github.com/hannesm/jackline";
    description = "minimalistic secure XMPP client in OCaml";
    mainProgram = "jackline";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
