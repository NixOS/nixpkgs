{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-sdd-parser";
  crate = "arkhe-sdd-parser";
  bin = "arkhe-sdd-parser";
  inherit src contentAddressed version;

  # Testes puros (spec.md/tasks.md -> CBOR canônico), sem rede nem banco.
  doCheck = true;

  meta = {
    description = "Converte spec.md/tasks.md SDD em CBOR canônico Arkhe";
  };
}
