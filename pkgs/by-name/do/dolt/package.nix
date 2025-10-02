{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "1.59.10";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DfocUOHpPdNeMcL7kVm7ggm2cVgWp/ifvCFyFosxhcs=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-yZ+q4KNfIiR2gpk10dpZOMiEN3V/Lk/pzhgaqp7lKag=";
  proxyVendor = true;
  doCheck = false;

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danbst ];
  };
})
