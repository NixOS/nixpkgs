{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dirsearch";
  version = "0.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = "dirsearch";
    rev = "v${version}";
    hash = "sha256-eXB103qUB3m7V/9hlq2xv3Y3bIz89/pGJsbPZQ+AZXs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    pysocks
    jinja2
    certifi
    urllib3
    cryptography
    cffi
    defusedxml
    markupsafe
    pyopenssl
    idna
    chardet
    charset-normalizer
    requests
    requests-ntlm
    colorama
    # ntlm-auth is unused?
    pyparsing
    beautifulsoup4
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];
  pythonImportsCheck = [ "dirsearch" ];
  # Requires network connection
  disabledTestPaths = [
    "tests/reports/test_reports.py"
    "tests/utils/test_schemedet.py"
  ];

  # setup.py creates a new temp directory for build
  preInstall = ''
    cp -r $TMP/dirsearch-install-*/dist .
  '';

  meta = {
    description = "Advanced web path scanner";
    homepage = "https://github.com/maurosoria/dirsearch";
    license = lib.licenses.gpl2Only;
    mainProgram = "dirsearch";
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
