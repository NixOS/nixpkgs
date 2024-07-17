{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
  why3,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "easycrypt";
  version = "2024.01";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "r${version}";
    hash = "sha256-UYDoVMi5TtYxgPq5nkp/oRtcMcHl2p7KAG8ptvuOL5U=";
  };

  nativeBuildInputs = with ocamlPackages; [
    dune_3
    findlib
    menhir
    ocaml
    python3.pkgs.wrapPython
  ];
  buildInputs = with ocamlPackages; [
    batteries
    dune-build-info
    inifiles
    why3
    yojson
    zarith
  ];

  propagatedBuildInputs = [ why3.out ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace dune-project --replace '(name easycrypt)' '(name easycrypt)(version ${version})'
  '';

  pythonPath = with python3.pkgs; [ pyyaml ];

  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${pname}
    rm $out/bin/ec-runtest
    wrapPythonProgramsIn "$out/lib/easycrypt/commands" "$pythonPath"
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
    homepage = "https://easycrypt.info/";
    description = "Computer-Aided Cryptographic Proofs";
    mainProgram = "easycrypt";
  };
}
