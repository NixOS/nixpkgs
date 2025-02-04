{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

with ocamlPackages;

buildDunePackage rec {
  pname = "jackline";
  version = "unstable-2024-10-21";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "hannesm";
    repo = "jackline";
    rev = "cf6b26e37e37b0b48be9fd2e74fc563375f757f0";
    hash = "sha256-6QZZ77C1G3x/GOJsUEQMrCatVsyyxNjq36ez/TgeHSY=";
  };

  nativeBuildInputs = [
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
