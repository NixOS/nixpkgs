{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "stanc";
  version = "2.36.0";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = "stanc3";
    rev = "v${version}";
    hash = "sha256-IrpHV00Fn3Nxail4Xgv/8ezclKpyVuQa1F34kF07wwA=";
  };

  nativeBuildInputs = with ocamlPackages; [ menhir ];

  buildInputs = with ocamlPackages; [
    core_unix
    menhirLib
    ppx_deriving
    fmt
    yojson
  ];

  meta = with lib; {
    homepage = "https://github.com/stan-dev/stanc3";
    description = "Stan compiler and utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
