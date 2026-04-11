{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "apkid";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rednaga";
    repo = "APKiD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/8p2qR1je65k1irXFcCre2e16rhGjcu0+u6RChMYTWQ=";
  };

  postPatch = ''
    # We have dex support enabled in yara-python
    substituteInPlace setup.py \
      --replace "yara-python-dex>=1.0.1" "yara-python"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ yara-python ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  preBuild = ''
    # Prepare the YARA rules
    ${python3.interpreter} prep-release.py
  '';

  pythonImportsCheck = [ "apkid" ];

  meta = {
    description = "Android Application Identifier";
    homepage = "https://github.com/rednaga/APKiD";
    changelog = "https://github.com/rednaga/APKiD/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apkid";
  };
})
