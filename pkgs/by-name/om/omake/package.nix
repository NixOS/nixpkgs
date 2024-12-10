{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:

stdenv.mkDerivation rec {

  pname = "omake";
  version = "0.10.6";

  src = fetchurl {
    url = "http://download.camlcity.org/download/${pname}-${version}.tar.gz";
    hash = "sha256-AuSZEnybyk8HaDZ7mbwDqjFXMXVQ7TDRuRU/aRY8/yE=";
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
}
