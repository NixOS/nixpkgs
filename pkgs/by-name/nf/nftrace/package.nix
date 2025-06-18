{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "nftrace";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "aojea";
    repo = "nftrace";
    tag = "v${version}";
    hash = "sha256-MTLl3XLDIjcK5GymW7D3B8+/A6W+kQ4cz5bbrfo6fQc=";
  };

  vendorHash = "sha256-UrsvUMdLWGX2QRFLxBLvMW1B5vZdcWI/lpyKiNAtA2o=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Commodity tool to use nftables trace functionality";
    homepage = "https://github.com/aojea/nftrace";
    changelog = "https://github.com/aojea/nftrace/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "nftrace";
  };
}
