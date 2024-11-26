# Build one of the packages that comes with idris
# pname: The pname of the package
# deps: The dependencies of the package
{ idris, build-idris-package }:
pname: deps:
let
  inherit (builtins.parseDrvName idris.name) version;
in
build-idris-package {

  inherit pname version;
  inherit (idris) src;

  noPrelude = true;
  noBase = true;

  idrisDeps = deps;

  postUnpack = ''
    sourceRoot=$sourceRoot/libs/${pname}
  '';

  meta = idris.meta // {
    description = "${pname} builtin Idris library";
  };
}
