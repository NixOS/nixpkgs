{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "lazycommit";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "m7medvision";
    repo = "lazycommit";
    tag = "v${version}";
    hash = "sha256-DD3DXTev8WHNkAYDrPY2PISuA8WwKuK0GCLebpn01Rg=";
  };

  vendorHash = "sha256-4OPCUWXxsAnzxsqZPHhjvhxQQf5Knm7nGqrdjH4I4YY=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.buildSource=nix"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Simple cli for generating git commits";
    homepage = "https://github.com/m7medvision/lazycommit";
    changelog = "https://github.com/m7medvision/lazycommit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      m7medvision
    ];
    mainProgram = "lazycommit";
  };
}
