{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  loguru,
  python-dateutil,
  pyyaml,
  tqdm,
  click,
}:

buildPythonPackage rec {
  pname = "bubop";
  version = "0.1.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "bubop";
    rev = "v${version}";
    hash = "sha256-p4Mv73oX5bsYKby7l0nGon89KyAMIUhDAEKSTNB++Cw=";
  };

  postPatch = ''
    # Those versions seems to work with `bubop`.
    substituteInPlace pyproject.toml \
    --replace-fail 'loguru = "^0.5.3"' 'loguru = "^0.7"' \
    --replace-fail 'PyYAML = "~5.3.1"' 'PyYAML = "^6.0"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    loguru
    python-dateutil
    pyyaml
    tqdm
    click
  ];

  pythonImportsCheck = [ "bubop" ];

  meta = with lib; {
    description = "Bergercookie's Useful Bits Of Python; helper libraries for Bergercookie's programs";
    homepage = "https://github.com/bergercookie/bubop";
    changelog = "https://github.com/bergercookie/bubop/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
