{
  fetchFromGitHub,
  icu,
  lib,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dolt";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNVlKVq0TohF39qaWzD3LQCx963+CpG6t83N/J21FW4=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-SbgjbR10VTMtPyGfTw/85/dTW74nW2HUw77slXEympc=";
  proxyVendor = true;
  doCheck = false;

  buildInputs = [ icu ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ VZstless ];
  };
})
