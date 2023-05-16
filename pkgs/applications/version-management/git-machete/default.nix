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
<<<<<<< HEAD
  version = "3.17.9";
=======
  version = "3.17.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oU4c57XU/DLGjOl/CyCt6oG3QaB2xnrOEg+sUAd7sww=";
=======
    hash = "sha256-XBgYLrbxHE5czcEzYhX4ORQFtyKHcDw3VmZVx2TtycI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    pytest-mock
    pytestCheckHook
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
  };
}
