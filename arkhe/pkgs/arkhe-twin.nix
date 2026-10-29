{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-twin";
  crate = "arkhe-twin";
  bin = "arkhe-twin";
  inherit src contentAddressed version;

  doCheck = false;

  meta = {
    description = "Gêmeo digital Arkhe (CLI de evidência)";
  };
}
