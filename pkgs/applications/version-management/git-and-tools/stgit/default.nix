{ lib, python3Packages, fetchFromGitHub, git, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "stacked-git";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "sha256-gfPf1yRmx1Mn1TyCBWmjQJBgXLlZrDcew32C9o6uNYk=";
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
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jshholland ];
  };
}
