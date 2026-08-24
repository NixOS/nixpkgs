{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KwN0na1G2M9hnPQqraRF8UhU8P3efv6DYXj3WEBCBDA=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-28lZ8rL/X/Lgxi1kwg62Wk97M/lEFqhllUAmnq8v54c=";
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
