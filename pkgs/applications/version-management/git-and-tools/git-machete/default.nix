{ lib, buildPythonApplication, fetchPypi
, installShellFiles, pbr
, flake8, mock, pycodestyle, pylint, tox }:

buildPythonApplication rec {
  pname = "git-machete";
  version = "2.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kmwm9rwngxm2qdlv6nvxyhwpfa0i95kbrmasrj1qqdz7rmyyzmi";
  };

  nativeBuildInputs = [ installShellFiles pbr ];

  # TODO: Add missing check inputs (2019-11-22):
  # - stestr
  doCheck = false;
  checkInputs = [ flake8 mock pycodestyle pylint tox ];

  postInstall = ''
      installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
      installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
  '';

  meta = with lib; {
    homepage = https://github.com/VirtusLab/git-machete;
    description = "Git repository organizer and rebase workflow automation tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.blitz ];
  };
}
