{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pdnsgrep";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "pdnsgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O1oTVdzptLBv47xp8JurSC4c6ofGOr1FKPOkiUizg+w=";
  };

  vendorHash = "sha256-Rx2TmYubU+EqvfyWjX5A3EC+7Pt/k68I6PmQdCwYlfE=";
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
