{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-python-gate";
  crate = "arkhe-python-bridge";
  bin = "arkhe-python-gate";
  inherit src contentAddressed version;

  doCheck = false;

  meta = {
    description = "Gate de execução para o runtime Python do Arkhe";
  };
}
