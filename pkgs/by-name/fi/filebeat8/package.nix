{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "filebeat";
  version = "8.17.1";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${version}";
    hash = "sha256-I245j8Atnp7r0ZL6Lfew0I4uluSodeNnYWFs3x/JYUc=";
  };

  vendorHash = "sha256-eGvpeik7kU/OC1bI4hjavEyF7GvQWXHsNlF+1Smn22c=";

  subPackages = [ "filebeat" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "version" ];
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
