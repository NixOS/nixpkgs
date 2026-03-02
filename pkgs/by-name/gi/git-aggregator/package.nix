{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-aggregator";
  version = "4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "git-aggregator";
    tag = finalAttrs.version;
    hash = "sha256-sZYh3CN15WTCQ59W24ERJdP48EJt571cbkswLQ3JL2g=";
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

  meta = {
    description = "Manage the aggregation of git branches from different remotes to build a consolidated one";
    homepage = "https://github.com/acsone/git-aggregator";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ bbjubjub ];
    mainProgram = "gitaggregate";
  };
})
