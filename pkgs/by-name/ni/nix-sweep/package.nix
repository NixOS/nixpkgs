{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-sweep";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jzbor";
    repo = "nix-sweep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C83AtqexEzx+8cNZXZyYUtg4gAUyam00IM0eXO8xOgA=";
  };

  cargoHash = "sha256-etqSdtoiSPMQLuMgBK/nnJM8dDTdmRk+MT++zu/9IjM=";

  nativeBuildInputs = [
    installShellFiles
  ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir ./manpages
    $out/bin/nix-sweep man ./manpages
    installManPage ./manpages/*
    mkdir ./completions
    $out/bin/nix-sweep completions ./completions
    installShellCompletion completions/nix-sweep.{bash,fish,zsh}
  '';

  meta = {
    description = "Utility to clean up old Nix profile generations and left-over garbage collection roots";
    homepage = "https://github.com/jzbor/nix-sweep";
    changelog = "https://github.com/jzbor/nix-sweep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "nix-sweep";
    maintainers = with lib.maintainers; [
      jzbor
    ];
  };
})
