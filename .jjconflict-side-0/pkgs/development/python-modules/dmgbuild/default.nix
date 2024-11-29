{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ds-store,
  importlib-resources,
  mac-alias,
}:

buildPythonPackage rec {
  pname = "dmgbuild";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmgbuild";
    repo = "dmgbuild";
    rev = "refs/tags/v${version}";
    hash = "sha256-PozYxmXumFnptIgb4FM4b/Q5tx0MIS2bVw2kCuGucA8=";
  };

  postPatch = ''
    # relax all deps
    substituteInPlace pyproject.toml \
      --replace-fail "==" ">="
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    ds-store
    importlib-resources
    mac-alias
  ];

  pythonImportsCheck = [
    "dmgbuild"
  ];

  # require permissions to access TextEditor.app
  # https://github.com/dmgbuild/dmgbuild/blob/refs/tags/v1.6.2/tests/examples/settings.py#L17
  doCheck = false;

  meta = {
    description = "MacOS command line utility to build disk images";
    homepage = "https://github.com/dmgbuild/dmgbuild";
    changelog = "https://github.com/dmgbuild/dmgbuild/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "dmgbuild";
    platforms = lib.platforms.darwin;
  };
}
