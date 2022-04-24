{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2021-12-28";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "ca1012098d123c555e9fa5244466d2e009521700";
    sha256 = "1j1azskcdrp4g44rv3a4zylkzbzpcs23zzzrx94llbgssw6cd9ih";
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
