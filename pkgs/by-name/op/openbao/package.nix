{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  nixosTests,
  callPackage,
  stdenvNoCC,
  withUi ? true,
  withHsm ? stdenvNoCC.hostPlatform.isLinux,
}:

buildGoModule (finalAttrs: {
  pname = "openbao";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4w+CkYhFS/P9ZeHiR2daK+DujqCKzF/aUAZbMcHqvyk=";
  };

  vendorHash = "sha256-3QNiw3q0dhgWeGFBq4a5GCE3bIIa4YiJRKMU+Hakvx0=";

  proxyVendor = true;

  subPackages = [ "." ];

  tags = lib.optional withHsm "hsm" ++ lib.optional withUi "ui";

  ldflags = [
    "-s"
    "-X github.com/openbao/openbao/version.GitCommit=${finalAttrs.src.rev}"
    "-X github.com/openbao/openbao/version.fullVersion=${finalAttrs.version}"
    "-X github.com/openbao/openbao/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postConfigure = lib.optionalString withUi ''
    cp -r --no-preserve=mode ${finalAttrs.passthru.ui} http/web_ui
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
