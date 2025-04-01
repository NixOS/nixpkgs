{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go_1_24,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule.override { go = go_1_24; } rec {
  pname = "openbao";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    tag = "v${version}";
    hash = "sha256-dDMOeAceMaSrF7P4JZ2MKy6zDa10LxCQKkKwu/Q3kOU=";
  };

  vendorHash = "sha256-zcMc63B/jTUykPfRKvea27xRxjOV+zytaxKOEQAUz1Q=";

  proxyVendor = true;

  subPackages = [ "." ];

  tags = [
    "openbao"
    "bao"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openbao/openbao/version.GitCommit=${src.rev}"
    "-X github.com/openbao/openbao/version.fullVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/openbao $out/bin/bao
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bao";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) openbao; };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation";
    changelog = "https://github.com/openbao/openbao/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "bao";
    maintainers = with lib.maintainers; [ brianmay ];
  };
}
