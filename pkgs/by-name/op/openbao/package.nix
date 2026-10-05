{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  nixosTests,
  callPackage,
  withUi ? true,
}:

buildGo127Module (finalAttrs: {
  pname = "openbao";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPmFX4gApN49399Yi8r+1TEJS8i9GD2KGy621axRNPk=";
  };

  vendorHash = "sha256-cm5NiwDX8TgH77vDLea37eRJi5CAIVQGspy65uCq24U=";

  proxyVendor = true;

  subPackages = [ "." ];

  tags = lib.optional withUi "ui";

  ldflags = [
    "-s"
    "-X github.com/openbao/openbao/v2/internal/version.GitCommit=${finalAttrs.src.rev}"
    "-X github.com/openbao/openbao/v2/internal/version.fullVersion=${finalAttrs.version}"
    "-X github.com/openbao/openbao/v2/internal/version.CommitDate=1970-01-01T00:00:00Z"
  ];

  postConfigure = lib.optionalString withUi ''
    cp -r --no-preserve=mode ${finalAttrs.passthru.ui} internal/http/web_ui
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/openbao $out/bin/bao

    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    installShellCompletion --bash --name bao <(echo complete -C "$out/bin/bao" bao)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bao";
  doInstallCheck = true;

  passthru = {
    ui = callPackage ./ui.nix { };
    tests = { inherit (nixosTests) openbao; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "ui"
      ];
    };
  };

  meta = {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation";
    changelog = "https://github.com/openbao/openbao/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "bao";
    maintainers = with lib.maintainers; [
      brianmay
      emilylange
    ];
  };
})
