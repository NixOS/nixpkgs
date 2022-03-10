{ lib
, buildPythonApplication
, fetchFromGitHub
, installShellFiles
, git
, stestr
, nix-update-script
, testVersion
, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7WaLUCJr29i7JW5YAJG1AuYnSLKRMpAEnCY2i4Zle+c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git stestr ];

  postCheck = ''
    stestr run
  '';

  postInstall = ''
    installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
    installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
  '';

  postInstallCheck = ''
    git init
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
