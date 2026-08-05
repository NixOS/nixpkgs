{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.19";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3hvP+4U3PWlOsaLHO1MZuIpcB6YzPv2dMPlC68esiHE=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-e++Y5mhwms/uJnZCUyZNifoYqGH4TGEugSFHSGl0AQE=";

  subPackages = [ "filebeat" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=v(8\\..*)" ]; };
  };

  meta = {
    description = "Tails and ships log files";
    homepage = "https://github.com/elastic/beats";
    changelog = "https://www.elastic.co/guide/en/beats/libbeat/${lib.versions.majorMinor finalAttrs.version}/release-notes-${finalAttrs.version}.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ srhb ];
    mainProgram = "filebeat";
  };
})
