{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
}:
let
  inherit (buildPackages) ocamlPackages;
in
stdenv.mkDerivation (finalAttrs: {
  version = "0.3.3";
  pname = "opaline";

  src = fetchFromGitHub {
    owner = "jaapb";
    repo = "opaline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6htaiFIcRMUYWn0U7zTNfCyDaTgDEvPch2q57qzvND4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # needed for pkgsStatic.opaline
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    ocamlbuild
  ];
  buildInputs = with ocamlPackages; [ opam-file-format ];

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OPAm Light INstaller Engine";
    mainProgram = "opaline";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/jaapb/opaline";
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
})
