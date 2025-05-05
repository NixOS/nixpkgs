{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  docopt,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage {
  pname = "docopt-subcommands";
  version = "4.0.0-unstable-2020-01-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abingham";
    repo = "docopt-subcommands";
    rev = "5693cbac24701c53e55fa182c1d563736e6a0557"; # no tags
    hash = "sha256-bNFmRMzyC9BQB/J0ACqYxkS7lHG4CWd5/by7QgCopFo=";
  };

  build-system = [ setuptools ];

  dependencies = [ docopt ];

  pythonImportsCheck = [ "docopt_subcommands" ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = {
    description = "Create subcommand-based CLI programs with docopt";
    homepage = "https://github.com/abingham/docopt-subcommands";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
