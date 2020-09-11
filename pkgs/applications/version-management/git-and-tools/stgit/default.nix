{ stdenv, python3Packages, fetchFromGitHub, git, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "1r9y8qnl6kdvq61788pnfhhgyv2xrnyrizbhy4qz4l1bpqkwfr2r";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git ];

  postInstall = ''
    installShellCompletion $out/share/stgit/completion/stg.fish
    installShellCompletion --name stg $out/share/stgit/completion/stgit.bash
    installShellCompletion --name _stg $out/share/stgit/completion/stgit.zsh
  '';

  meta = with stdenv.lib; {
    description = "A patch manager implemented on top of Git";
    homepage = "http://procode.org/stgit/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
