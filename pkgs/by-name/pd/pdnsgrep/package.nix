{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pdnsgrep";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "pdnsgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NFJkLYOHBUYRVehT0VBIFPagLiR8cVvVkAnqCwVUqYg=";
  };

  vendorHash = "sha256-kbX3oTg2OGr4Gj9MEXa2Z7AlYIyv6LNIY4mR06F6OvQ=";
  proxyVendor = true;

  ldflags = [
    "-s"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search tool for PowerDNS logs";
    homepage = "https://github.com/akquinet/pdnsgrep";
    changelog = "https://github.com/akquinet/pdnsgrep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "pdnsgrep";
  };
})
