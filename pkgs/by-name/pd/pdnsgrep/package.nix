{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pdnsgrep";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "pdnsgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bkCd5fIXj3qdbXmHCsnA9yi1LMYbIFdei72kaj2Uxzs=";
  };

  vendorHash = "sha256-hTlweJAWWrcaYhTH8IuCxDmqNd1qWTYK5F8NQhBbKt0=";
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
