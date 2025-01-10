{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2023-03-09";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "jackline";
    rev    = "a7acd19bd8141b842ac69b05146d9a63e729230d";
    hash = "sha256-AhiFfZkDit9tnGenETc3A1hHqWN+csiS2bVjsGNaHf8=";
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
