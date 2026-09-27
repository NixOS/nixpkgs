{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QkeL/dx9Fwa6f8Xbpo6tblWy7iANe6DISKbmey5QKJ0=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-AZKgx1rmp+lZzYxWywoKE2VQ/rn5B+2XyqNMl2XPhTA=";
  proxyVendor = true;
  doCheck = false;

  buildInputs = [ icu ];

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
