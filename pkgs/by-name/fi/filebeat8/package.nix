{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "filebeat";
  version = "8.19.3";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${version}";
    hash = "sha256-bw/qWsNT4tG+hUjeb+DXaTxDY6HEL/A9iANFLdbyi5E=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-t+rCXm2eIG2a5xW1E8SjRAb/w9OuFKC/PyCGpJP8Szc=";

  subPackages = [ "filebeat" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=v(8\..*)" ]; };
  };

  meta = {
    description = "Tails and ships log files";
    homepage = "https://github.com/elastic/beats";
    changelog = "https://www.elastic.co/guide/en/beats/libbeat/${version}/release-notes-${version}.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ srhb ];
    mainProgram = "filebeat";
  };
}
