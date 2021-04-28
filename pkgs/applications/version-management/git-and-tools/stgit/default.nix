{ lib, python3Packages, fetchFromGitHub, git, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "16q8994widg040n1ag4m82kbn3r02n39ah7dvwa7aixhw5y35vlm";
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
    homepage = "https://stacked-git.github.io/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
