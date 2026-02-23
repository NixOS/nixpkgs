{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "stanc";
  version = "2.37.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "stanc3";
    tag = "v${version}";
    hash = "sha256-d+sInQfnlT1gLbtIRPD+LUZgIdl519OrfvgSNYdYeII=";
  };

  nativeBuildInputs = with ocamlPackages; [ menhir ];

  buildInputs = with ocamlPackages; [
    core_unix
    menhirLib
    ppx_deriving
    fmt
    yojson
    cmdliner_1
  ];

  meta = {
    homepage = "https://github.com/stan-dev/stanc3";
    description = "Stan compiler and utilities";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
