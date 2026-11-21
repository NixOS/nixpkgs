{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "sqlgg";
  version = "20260721";

  src = fetchFromGitHub {
    owner = "ygrek";
    repo = "sqlgg";
    tag = finalAttrs.version;
    sha256 = "sha256-I0a+wZ8aWWLjxv6fBCKA/ijFOwTkALsOcVenG4Ykzxg=";
  };

  nativeBuildInputs = with ocamlPackages; [
    menhir
  ];

  buildInputs = with ocamlPackages; [
    mybuild
    extlib
    integers
    odoc
    ounit
    ppx_deriving
    yojson
  ];

  __structuredAttrs = true;

  meta = {
    description = "SQL query parser and binding code generator for C#, C++, Java, OCaml";
    homepage = "https://ygrek.org/p/sqlgg/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.niols ];
    platforms = lib.platforms.all;
  };
})
