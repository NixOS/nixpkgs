{ lib
, buildPythonApplication
, pytest-mock
, pytestCheckHook
, fetchFromGitHub
, installShellFiles
, git
, nix-update-script
, testers
, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2oEpBNMHj4qpkPp8rXEMsRRiRQeC30hQCQh7d8bOLUU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    pytest-mock
    pytestCheckHook
  ];

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

  meta = with lib; {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    changelog = "https://github.com/VirtusLab/git-machete/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ blitz ];
    mainProgram = "git-machete";
  };
}
