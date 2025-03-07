{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offensive-azure";
  version = "0.4.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5JHix+/uGGhXM89VLimI81g4evci5ZUtNV1c1xopjuI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    charset-normalizer
    colorama
    dnspython
    idna
    pycryptodome
    python-whois
    requests
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    # Use default Python module
    substituteInPlace pyproject.toml \
      --replace 'uuid = "^1.30"' "" \
      --replace 'python-whois = "^0.7.3"' 'python-whois = "*"'
  '';

  pythonImportsCheck = [
    "offensive_azure"
  ];

  meta = with lib; {
    description = "Collection of offensive tools targeting Microsoft Azure";
    homepage = "https://github.com/blacklanternsecurity/offensive-azure";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
