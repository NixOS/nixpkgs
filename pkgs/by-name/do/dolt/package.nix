{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KCefzDqFMXpqtPPVOyD41hdM9j7p1kftO1cNaGzDT0w=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-CEqdHw9cFLcoewQyd4Y1yXdkSAdaQ/cRyVTxa5qCyMM=";
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
