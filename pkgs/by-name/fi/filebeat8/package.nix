{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "filebeat";
  version = "8.17.4";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${version}";
    hash = "sha256-m3TJaYmmyE+MXGCiRnuGCObyv0QPrvN7imI2lWtoAn8=";
  };

  vendorHash = "sha256-D24ViZv34mhv8S4l1O8cup54e7wXT5MyZ/HkkBO4bOo=";

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
