{
  lib,
  nix-update-script,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "legendary-gl"; # Name in pypi
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "legendary-gl";
    repo = "legendary";
    tag = finalAttrs.version;
    hash = "sha256-k5zVjXibYWS0F1by1uNOynuun9WfU0WuK3ResqsG7I0=";
  };

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    pycryptodomex
    requests
    filelock
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "legendary" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free and open-source Epic Games Launcher alternative";
    homepage = "https://github.com/legendary-gl/legendary";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ equirosa ];
    mainProgram = "legendary";
  };
})
