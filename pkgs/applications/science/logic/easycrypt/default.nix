{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  ocamlPackages,
  dune,
  why3,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easycrypt";
  version = "2026.03";

  src = fetchFromGitHub {
    owner = "easycrypt";
    repo = "easycrypt";
    tag = "r${finalAttrs.version}";
    hash = "sha256-GkZSsVLnJg0/P5nRAHrmj64NmpT99jc2tvK0B/6FE7s=";
  };

  nativeBuildInputs =
    with ocamlPackages;
    [
      dune
      findlib
      menhir
      ocaml
      python3.pkgs.wrapPython
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.sigtool;

  buildInputs = with ocamlPackages; [
    batteries
    dune-build-info
    dune-site
    markdown
    pcre2
    why3
    yojson
    zarith
  ];

  propagatedBuildInputs = [ why3.out ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace dune-project --replace-fail '(name easycrypt)' '(name easycrypt)(version ${finalAttrs.version})'
  '';

  pythonPath = with python3.pkgs; [ pyyaml ];

  installPhase = ''
    runHook preInstall
    dune install --prefix $out easycrypt
    rm $out/bin/ec-runtest
    wrapPythonProgramsIn "$out/lib/easycrypt/commands" "''${pythonPath[*]}"
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
})
