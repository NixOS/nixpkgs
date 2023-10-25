{ lib, stdenv, fetchFromGitHub, ocamlPackages, why3 }:

stdenv.mkDerivation rec {
  pname = "easycrypt";
  version = "2023.09";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "r${version}";
    hash = "sha256-9xavU9jRisZekPqC87EyiLXtZCGu/9QeGzq6BJGt1+Y=";
  };

  nativeBuildInputs = with ocamlPackages; [
    dune_3
    findlib
    menhir
    ocaml
  ];
  buildInputs = with ocamlPackages; [
    batteries
    dune-build-info
    inifiles
    yojson
    zarith
  ];

  propagatedBuildInputs = [ why3 ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace dune-project --replace '(name easycrypt)' '(name easycrypt)(version ${version})'
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${pname}
    rm $out/bin/ec-runtest
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
    homepage = "https://easycrypt.info/";
    description = "Computer-Aided Cryptographic Proofs";
  };
}
