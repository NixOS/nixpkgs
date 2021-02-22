{ lib, buildPythonApplication, fetchPypi
, installShellFiles, pbr
, flake8, mock, pycodestyle, pylint, tox }:

buildPythonApplication rec {
  pname = "git-machete";
  version = "2.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00xh3q3gmi88qcl0a61pw532iyw4xcls5h336cjzld70ps2r89g4";
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
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.blitz ];
  };
}
