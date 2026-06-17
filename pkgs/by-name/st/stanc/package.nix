{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "stanc";
  version = "2.38.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "stanc3";
    tag = "v${version}";
    hash = "sha256-j05PMQKIqkM9UWJzSVnkYWe6d+iUnmFOh1W8pZ7Fdyk=";
  };

  nativeBuildInputs = with ocamlPackages; [
    cmdliner
    menhir
  ];

  buildInputs = with ocamlPackages; [
    core_unix
    menhirLib
    ppx_deriving
    fmt
    yojson
    cmdliner
  ];

  meta = {
    homepage = "https://github.com/stan-dev/stanc3";
    description = "Stan compiler and utilities";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
