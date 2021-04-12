{ lib, python3Packages, fetchFromGitHub, git, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "0nc388hi362rks9q60yvs2gbbf9v6qp031c0linv29wdqvavwva1";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git ];

  postInstall = ''
    installShellCompletion $out/share/stgit/completion/stg.fish
    installShellCompletion --name stg $out/share/stgit/completion/stgit.bash
    installShellCompletion --name _stg $out/share/stgit/completion/stgit.zsh
  '';

  meta = with lib; {
    description = "A patch manager implemented on top of Git";
    homepage = "http://procode.org/stgit/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
