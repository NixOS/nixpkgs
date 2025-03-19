{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-aggregator";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "git-aggregator";
    tag = version;
    hash = "sha256-6o+bf3s5KyRQWA7hp3xk76AfxBdzP0lOBOozgwe3Wtw=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    colorama
    gitMinimal
    kaptan
    requests
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
    git config --global user.name John
    git config --global user.email john@localhost
    git config --global init.defaultBranch master
    git config --global pull.rebase false
  '';

  meta = with lib; {
    description = "Manage the aggregation of git branches from different remotes to build a consolidated one";
    homepage = "https://github.com/acsone/git-aggregator";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ bbjubjub ];
    mainProgram = "gitaggregate";
  };
}
