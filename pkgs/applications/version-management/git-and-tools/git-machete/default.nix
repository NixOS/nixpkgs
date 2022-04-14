{ lib
, buildPythonApplication
, fetchFromGitHub
, installShellFiles
, git
, nix-update-script
, testVersion
, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WVPcyooShgFPZaIfEzV2zUA6tCHhuTM8MbrGVNr0neM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git ];

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
