{ lib, stdenv, fetchFromGitHub, ocamlPackages, why3 }:

stdenv.mkDerivation rec {
  pname = "easycrypt";
  version = "2022.04";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256:09rdwcj70lkamkhd895p284rfpz4bcnsf55mcimhiqncd2a21ml7";
  };

  nativeBuildInputs = with ocamlPackages; [
    dune_2
    findlib
    menhir
    ocaml
  ];
  buildInputs = with ocamlPackages; [
    batteries
    dune-build-info
    inifiles
    menhirLib
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
