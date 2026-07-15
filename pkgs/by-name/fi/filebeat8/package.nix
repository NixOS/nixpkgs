{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.17";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xpth1SoXMXCUh/DFf3wA+Ql6SedtUB7tCYzDElpX5Lc=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-Wxk+eI0XfBpQqqUNuskyr+/bTRqT38hszdkz/LJweQo=";

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
