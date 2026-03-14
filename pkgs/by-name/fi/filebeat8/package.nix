{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.12";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OdC1SnrYrNXkRyFEqcDIbdVZaxsnXOajKZMJAKNhnhQ=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-X0OMbjs4HtsyN7vrAHgoPZRv9N+f5hY/Y+JO3vVrMbc=";

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
    changelog = "https://www.elastic.co/guide/en/beats/libbeat/${finalAttrs.version}/release-notes-${finalAttrs.version}.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ srhb ];
    mainProgram = "filebeat";
  };
})
