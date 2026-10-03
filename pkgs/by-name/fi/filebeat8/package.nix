{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "filebeat";
  version = "8.19.22";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+LFa1asLx0x0Gz467C7SZqxOggwKla9YfKw5w6nRSzI=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-O+4cl2SP32T5y65f2tWZJ1ZxdMnM8rNr493T2I8bC/s=";

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
