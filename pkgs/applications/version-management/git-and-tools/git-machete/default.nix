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
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jZkc9YA4kE/Gr4/FRzgd0VvEjSrw5rk7DB5qH8Z5o6c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git pytest-mock pytestCheckHook ];

  postInstall = ''
    installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
    installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
    installShellCompletion --fish completion/git-machete.fish
  '';

  postInstallCheck = ''
    test "$($out/bin/git-machete version)" = "git-machete version ${version}"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ blitz ];
  };
}
