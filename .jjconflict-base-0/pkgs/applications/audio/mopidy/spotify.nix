{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
  nix-update-script,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "5.0.0a3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "refs/tags/v${version}";
    hash = "sha256-pM+kqeWYiPXv9DZDBTgwiEwC6Sbqv6uz5vJ5odcixOw=";
  };

  build-system = [ pythonPackages.setuptools ];

  dependencies = [
    mopidy
    pythonPackages.pykka
    pythonPackages.requests
  ];

  optional-dependencies = {
    lint = with pythonPackages; [
      black
      check-manifest
      flake8
      flake8-bugbear
      isort
    ];

    test = with pythonPackages; [
      pytest
      pytest-cov
      responses
    ];

    dev = optional-dependencies.lint ++ optional-dependencies.test ++ [ pythonPackages.tox ];
  };

  nativeCheckInputs = [ pythonPackages.pytestCheckHook ] ++ optional-dependencies.test;

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mopidy extension for playing music from Spotify";
    homepage = "https://github.com/mopidy/mopidy-spotify";
    changelog = "https://github.com/mopidy/mopidy-spotify/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
