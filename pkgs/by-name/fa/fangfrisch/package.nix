{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,

  # support setting socks proxies in `ALL_PROXY` environment variable
  supportSocks ? true,
}:
let
  version = "1.9.3";
in
python3.pkgs.buildPythonApplication {
  pname = "fangfrisch";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "fangfrisch";
    tag = version;
    hash = "sha256-I80ih8vCZVEWJW3wOdHgVCvYg2+Qj/uMhOk5roofv/4=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      requests
      sqlalchemy
    ]
    ++ lib.optional supportSocks pysocks;

  pythonImportsCheck = [ "fangfrisch" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Update and verify unofficial Clam Anti-Virus signatures";
    homepage = "https://github.com/rseichter/fangfrisch";
    changelog = "https://github.com/rseichter/fangfrisch/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "fangfrisch";
  };
}
