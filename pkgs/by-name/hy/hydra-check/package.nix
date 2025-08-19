{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "hydra-check";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "hydra-check";
    tag = "v${version}";
    hash = "sha256-TdMZC/EE52UiJ+gYQZHV4/ReRzMOdCGH+n7pg1vpCCQ=";
  };

  cargoHash = "sha256-G9M+1OWp2jlDeSDFagH/YOCdxGQbcru1KFyKEUcMe7g=";

  patches =
    lib.optional (stdenv.hostPlatform.system == "x86_64-darwin")
      # work around rust 1.88 compiler / linker bug for x86_64-darwin. This is
      # applied conditionally because it will introduce a performance penalty on
      # other host platforms. NOTE: Please check the patch applies if you update
      # the package on a different platform (e.g x86_64-linux).
      # see: https://github.com/NixOS/nixpkgs/issues/427072
      ./fix-cargo-1_88-reqwest.patch;

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
}
