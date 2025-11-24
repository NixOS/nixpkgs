{
  lib,
  python3,
  fetchFromGitHub,
  installShellFiles,
  git,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-machete";
  version = "3.37.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = "git-machete";
    tag = "v${version}";
    hash = "sha256-E1rLMCFnczZqwxC+hNDCyhRFHM39/oQMlaa5D363Ac4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
  ]
  ++ (with python3.pkgs; [
    pytest-mock
    pytestCheckHook
  ]);

  disabledTests = [
    # Requires fully functioning shells including zsh modules and bash
    # completion.
    "completion_e2e"
  ];

  postInstall = ''
    installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
    installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
    installShellCompletion --fish completion/git-machete.fish
  '';

  postInstallCheck = ''
    test "$($out/bin/git-machete version)" = "git-machete version ${version}"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    changelog = "https://github.com/VirtusLab/git-machete/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blitz ];
    mainProgram = "git-machete";
  };
}
