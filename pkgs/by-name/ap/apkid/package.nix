{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkid";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rednaga";
    repo = "APKiD";
    tag = "v${version}";
    hash = "sha256-/8p2qR1je65k1irXFcCre2e16rhGjcu0+u6RChMYTWQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    yara-python
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  preBuild = ''
    # Prepare the YARA rules
    ${python3.interpreter} prep-release.py
  '';

  postPatch = ''
    # We have dex support enabled in yara-python
    substituteInPlace setup.py \
      --replace "yara-python-dex>=1.0.1" "yara-python"
  '';

  pythonImportsCheck = [
    "apkid"
  ];

  meta = with lib; {
    description = "Android Application Identifier";
    mainProgram = "apkid";
    homepage = "https://github.com/rednaga/APKiD";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
