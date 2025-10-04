{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:
ocamlPackages.buildDunePackage rec {
  pname = "hardcaml_waveterm";
  version = "v0.17";

  minimalOCamlVersion = "5.1.0";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "hardcaml_waveterm";
    rev = version;
    hash = "sha256-R7NTEJel52KjdzRrTtJaX0dx1kuzxVqNHGwi4ORaR9k=";
  };

  buildInputs = with ocamlPackages; [
    async
    base
    bignum
    core
    core_unix
    cryptokit
    hardcaml
    notty
    # notty_async
    ppx_jane
    re
    stdio
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/janestreet/hardcaml/tree/master";
    description = "Hardcaml is an OCaml library for designing hardware";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jleightcap ];
  };
}
