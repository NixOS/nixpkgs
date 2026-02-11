{
  lib,
  stdenv,
  fetchFromGitHub,
  opam-installer,
  ocamlPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opam2json";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "opam2json";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5pXfbUfpVABtKbii6aaI2EdAZTjHJ2QntEf0QD2O5AM=";
  };

  buildInputs = with ocamlPackages; [
    yojson
    opam-file-format
    cmdliner
  ];
  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    opam-installer
  ];

  preInstall = ''export PREFIX="$out"'';

  meta = {
    platforms = lib.platforms.all;
    description = "Convert opam file syntax to JSON";
    mainProgram = "opam2json";
    maintainers = [ lib.maintainers.balsoft ];
    license = lib.licenses.gpl3;
    homepage = "https://github.com/tweag/opam2json";
  };
})
