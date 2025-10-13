{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omake";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "ocaml-omake";
    repo = "omake";
    tag = "omake-${finalAttrs.version}";
    hash = "sha256-5ZOdY3uGcI0KGpnr7epUwe2ueKCoLeaHGzaiTiXLNoc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  meta = {
    description = "Build system designed for scalability and portability";
    homepage = "http://projects.camlcity.org/projects/omake.html";
    license = with lib.licenses; [
      mit # scripts
      gpl2 # program
    ];
    inherit (ocaml.meta) platforms;
  };
})
