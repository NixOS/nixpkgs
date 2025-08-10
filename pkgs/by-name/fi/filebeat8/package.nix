{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "filebeat";
  version = "8.18.4";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${version}";
    hash = "sha256-H7UKYp+REz7d9wKrP+AhIJp4ydCVS8NGKfBFvDFZWiA=";
  };

  proxyVendor = true; # darwin/linux hash mismatch

  vendorHash = "sha256-G4+FsmmPDyssD+n1N1BnCElYv/bW7kY2tF60r49ZhN8=";

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
