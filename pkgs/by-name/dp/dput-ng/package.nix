{
  lib,
  python3,
  fetchFromGitLab,
  nix-update-script,
}:
let
  version = "1.40";
in
python3.pkgs.buildPythonApplication {
  pname = "dput-ng";
  inherit version;
  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "dput-ng";
    rev = "refs/tags/${version}";
    hash = "sha256-97NrRUmIjrP41NyI4KOEzHLlaqxehZIhSVyx9hRZ0dw=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    jsonschema
    paramiko
    sphinx
    coverage
    xdg
    python-debian
  ];

  postInstall = ''
    cp -r bin $out/
  '';

  pythonImportsCheck = [ "dput" ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Requires running dpkg
  disabledTestPaths = [ "tests/test_upload.py" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation Debian package upload tool";
    homepage = "https://dput.readthedocs.io/en/latest/";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "dput";
  };
}
