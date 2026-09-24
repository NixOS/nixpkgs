{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  installShellFiles,
  scdoc,

  # nativeInstallCheckInputs
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mastermind";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mahyarmirrashed";
    repo = "mastermind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WWM3OnPJm5BvD2l5KnKrlfKqvMcyrpStcji1joq28hg=";
  };

  cargoHash = "sha256-N6zjgcaJRwRdmvIXzwFeiW1YCpRV6P2P7uj7D2EK0IQ=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = ''
    scdoc < doc/mastermind.6.scd > mastermind.6
    installManPage mastermind.6
  '';

  meta = {
    description = "A game of cunning and logic";
    homepage = "https://github.com/mahyarmirrashed/mastermind";
    license = lib.licenses.mit;
    mainProgram = "mastermind";
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})
