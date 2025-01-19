{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "filebeat";
  version = "7.17.27";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    tag = "v${version}";
    hash = "sha256-TzcKB1hIHe1LNZ59GcvR527yvYqPKNXPIhpWH2vyMTY=";
  };

  vendorHash = "sha256-JOCcceYYutC5MI+/lXBqcqiET+mcrG1e3kWySo3+NIk=";

  subPackages = [ "filebeat" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
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
