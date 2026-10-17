{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-outdated";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "replicatedhq";
    repo = "outdated";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01rQAGSoAD/lMHSth4FvYXnvpW2zyXGQNKq70HQKPFU=";
  };

  vendorHash = "sha256-EbLIsOqg4uQB6ER/H05zaFC6sTxCPIQUZUhRgW1i9KQ=";

  subPackages = [ "cmd/outdated" ];

  postInstall = ''
    mv $out/bin/outdated $out/bin/kubectl-outdated
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find and report outdated images running in Kubernetes";
    mainProgram = "kubectl-outdated";
    homepage = "https://github.com/replicatedhq/outdated";
    changelog = "https://github.com/replicatedhq/outdated/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
