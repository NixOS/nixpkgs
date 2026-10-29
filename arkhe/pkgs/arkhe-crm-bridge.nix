{ mkArkhePackage, src, contentAddressed, version }:

mkArkhePackage {
  pname = "arkhe-crm-bridge";
  crate = "arkhe-crm-bridge-cli";
  # O crate não declara [[bin]]; o binário tem o nome do pacote Cargo.
  bin = "arkhe-crm-bridge-cli";
  inherit src contentAddressed version;

  doCheck = false;

  meta = {
    description = "Ponte CRM ↔ Arkhe (CLI, SQLite embutido)";
  };
}
