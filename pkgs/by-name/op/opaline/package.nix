{ lib, stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
  version = "0.3.3";
  pname = "opaline";

  src = fetchFromGitHub {
    owner = "jaapb";
    repo = "opaline";
    rev = "v${version}";
    sha256 = "sha256-6htaiFIcRMUYWn0U7zTNfCyDaTgDEvPch2q57qzvND4=";
  };

  nativeBuildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild ];
  buildInputs = with ocamlPackages; [ opam-file-format ];

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OPAm Light INstaller Engine";
    mainProgram = "opaline";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
