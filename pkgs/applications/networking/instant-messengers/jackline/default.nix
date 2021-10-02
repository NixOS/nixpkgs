{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2021-08-10";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "73d87e9a62d534566bb0fbe64990d32d75487f11";
    sha256 = "0wk574rqfg2vqz27nasxzwf67x51pj5fgl4vkc27r741dg4q6c5a";
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
