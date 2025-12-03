{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "certinfo-go";
  version = "0.1.49";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${version}";
    hash = "sha256-28RlCPr3Y43MmVlzzdXp3fSti1zBGuBIYQMkszggAUs=";
  };

  vendorHash = "sha256-3Jnk2K1ZBfIXt4Oo8Znxqi6y7JzPG6gAKfZ30gHiFsw=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
