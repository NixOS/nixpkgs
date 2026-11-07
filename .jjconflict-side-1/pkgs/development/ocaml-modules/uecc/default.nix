{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  ocaml,
  bigstring,
  alcotest,
  cstruct,
  hex,
}:

buildDunePackage rec {
  pname = "uecc";
  version = "0.4";

  duneVersion = "3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ocaml-uecc";
    rev = "v${version}";
    hash = "sha256-o/DylUx+olRRloiCU6b1t/xOmW8A5IZB2n3U7fkMo80=";
  };

  propagatedBuildInputs = [
    bigstring
  ];

  checkInputs = [
    alcotest
    cstruct
    hex
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Bindings for ECDH and ECDSA for 8-bit, 32-bit, and 64-bit processors";
    homepage = "https://gitlab.com/nomadic-labs/ocaml-uecc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
