{
  buildDunePackage,
  pbrt,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "ocaml-protoc";

  inherit (pbrt) version src;

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ pbrt ];

  doCheck = true;

  meta = pbrt.meta // {
    description = "Protobuf Compiler for OCaml";
  };
}
