{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  ott,
  gmp,
  z3,
  makeWrapper,
}:

let
  # All packages defined in dune-project; backends are marked :post in sail.opam
  # so we build and install all of them together for dune-site plugin loading.
  sailPackages = [
    "sail_maker"
    "libsail"
    "sail_ocaml_backend"
    "sail_c_backend"
    "sail_smt_backend"
    "sail_sv_backend"
    "sail_lem_backend"
    "sail_coq_backend"
    "sail_lean_backend"
    "sail_output"
    "sail_latex_backend"
    "sail_doc_backend"
    "sail"
  ];
  packageList = lib.concatStringsSep "," sailPackages;
in
ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "sail-isa";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "sail";
    tag = finalAttrs.version;
    hash = "sha256-Wf2DJG5uA8JThQcgjzeiOsl6gtG8C2O1S0Q9CpqFuQA=";
  };

  outputs = [ "out" ];
  __structuredAttrs = true;

  nativeBuildInputs = [
    ott
    makeWrapper
    ocamlPackages.lem
    ocamlPackages.menhir
  ];

  propagatedBuildInputs = [
    gmp
    ocamlPackages.base64
    ocamlPackages.dune-site
    ocamlPackages.lem
    ocamlPackages.linenoise
    ocamlPackages.linksem
    ocamlPackages.menhirLib
    ocamlPackages.omd
    ocamlPackages.pprint
    ocamlPackages.yojson
    ocamlPackages.zarith
  ];

  # Avoid `dune subst` failing in a git-less Nix sandbox; version is already in dune-project.
  dontUseDuneSubst = true;

  buildPhase = ''
    runHook preBuild
    dune build -p ${packageList} -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix=$out --libdir=$OCAMLFIND_DESTDIR ${lib.concatStringsSep " " sailPackages}
    wrapProgram $out/bin/sail \
      --prefix PATH : ${lib.makeBinPath [ z3 ]}
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Sail ISA specification language and compiler";
    homepage = "https://github.com/rems-project/sail";
    license = lib.licenses.bsd2;
    mainProgram = "sail";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ t520z520 ];
  };
})
