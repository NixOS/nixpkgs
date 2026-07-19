{
  lib,
  fetchFromGitHub,
  fetchpatch,
  pythonPackages,
  mopidy,
  nix-update-script,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-spotify";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0h1BkC3cY1klxVQ+QsyhY/ZJgbb+LlnDuQRYQbqpHJQ=";
  };

  patches = [
    # Fix single-argument parametrization with pytest 9.1.
    (fetchpatch {
      url = "https://github.com/mopidy/mopidy-spotify/commit/5fbc4104d78ef15f81ef080c427551f9d4369873.patch";
      hash = "sha256-JPy9l8uKWUggpfszpwfMiuNN8abnIlno+zOCB4r5s0s=";
    })
  ];

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.pykka
    pythonPackages.requests
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    pythonPackages.responses
  ];

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mopidy extension for playing music from Spotify";
    homepage = "https://github.com/mopidy/mopidy-spotify";
    changelog = "https://github.com/mopidy/mopidy-spotify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getchoo ];
  };
})
