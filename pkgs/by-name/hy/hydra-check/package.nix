{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  versionCheckHook,
  testers,
  curl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "hydra-check";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "hydra-check";
    tag = "v${version}";
    hash = "sha256-TdMZC/EE52UiJ+gYQZHV4/ReRzMOdCGH+n7pg1vpCCQ=";
  };

  cargoHash = "sha256-G9M+1OWp2jlDeSDFagH/YOCdxGQbcru1KFyKEUcMe7g=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hydra-check \
      --bash <($out/bin/hydra-check --shell-completion bash) \
      --fish <($out/bin/hydra-check --shell-completion fish) \
      --zsh <($out/bin/hydra-check --shell-completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.tests.mainCommand =
    testers.runCommand # allows internet access
      {
        name = "hydra-check-test";

        # only runs the test when internet access is confirmed:
        script = ''
          set -e
          if curl hydra.nixos.org > /dev/null; then
            hydra-check
          else
            echo "no internet access, skipping test"
          fi
          touch $out
        '';

        nativeBuildInputs = [
          finalAttrs.finalPackage
          curl
          cacert # for https connectivity
        ];
      };

  meta = {
    description = "Check hydra for the build status of a package";
    homepage = "https://github.com/nix-community/hydra-check";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      makefu
      artturin
      bryango
      doronbehar
    ];
    mainProgram = "hydra-check";
  };
})
