{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "1.59.2";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qIV4pbyrN40joXCgmE0e1EDkfRaHC/G1lwdkpzrO5fU=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-DPo1xzV11Q9emVIlrBFQcWXGNXKfYOKzR/hi5nJJp34=";
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
