{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "git-bug";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "git-bug";
    repo = "git-bug";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iLYhVv6QMZStuNtxvvIylFSVb1zLfC58NU2QJChFfug=";
  };

  vendorHash = "sha256-qztAkP+CHhryhfv1uKHEpDutofMwHGun7Vr30BHWAOE=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags =
    let
      integrationTests = [
        "TestValidateUsername/existing_organisation"
        "TestValidateUsername/existing_organisation_with_bad_case"
        "TestValidateUsername/existing_username"
        "TestValidateUsername/existing_username_with_bad_case"
        "TestValidateUsername/non_existing_username"
        "TestValidateProject/public_project"
      ];
    in
    [
      "-skip=^${lib.concatStringsSep "$|^" integrationTests}$"
    ];

  excludedPackages = [
    "doc"
    "misc"
  ];

  ldflags = [
    "-X github.com/git-bug/git-bug/commands.GitCommit=v${finalAttrs.version}"
    "-X github.com/git-bug/git-bug/commands.GitLastTag=${finalAttrs.version}"
    "-X github.com/git-bug/git-bug/commands.GitExactTag=${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion \
      --bash misc/completion/bash/git-bug \
      --zsh misc/completion/zsh/git-bug \
      --fish misc/completion/fish/git-bug

    installManPage doc/man/*
  '';

  meta = {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/git-bug/git-bug";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      royneary
      DeeUnderscore
      sudoforge
    ];
    mainProgram = "git-bug";
  };
})
