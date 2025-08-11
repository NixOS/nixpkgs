{
  lib,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3ZopogeRqsgaM/HEKlS6B0ipaDG/5mKUyzGET3P1e0=";
  };

  vendorHash = "sha256-D4uZmQKe4VuSpuW8JD5NOOq7Nvx8HRXzyvgzkBhsKLQ=";

  proxyVendor = true;

  patches = [
    (fetchpatch2 {
      # Temporarily revert upstream raising the min go version to 1.24.6
      # until that go version lands from staging in master.
      name = "revert-Bump-to-Go-1.24.6.patch";
      url = "https://github.com/openbao/openbao/commit/85504045ecf2d343b74be2c1cda6c2c0b0d6acff.patch?full_index=1";
      revert = true;
      hash = "sha256-tXSnnqrNxgnJ2ya4HjLSh4e+6hdyPgKRsFsmkMNfNRU=";
    })
  ];

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
  versionCheckProgramArg = "--version";
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
    maintainers = with lib.maintainers; [ brianmay ];
  };
})
