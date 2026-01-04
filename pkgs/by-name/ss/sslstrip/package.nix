{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sslstrip";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "L1ghtn1ng";
    repo = "sslstrip";
    tag = version;
    hash = "sha256-iPWpbRmAUf0Yf5MDlpln1JLBxMIdmr/Ggk2ZGeQzm8s=";
  };

  postPatch = ''
    # https://github.com/L1ghtn1ng/sslstrip/pull/58
    substituteInPlace setup.py \
      --replace-fail "README" "README.md"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cryptography
    pyopenssl
    service-identity
    twisted
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "sslstrip"
  ];

  meta = {
    description = "Tool for exploiting SSL stripping attacks";
    homepage = "https://github.com/L1ghtn1ng/sslstrip";
    changelog = "https://github.com/L1ghtn1ng/sslstrip/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sslstrip";
  };
}
