{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-footnote";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DUCBWcmB5i6/HkqxjlU3aTRO7i0n2sj+e/doKB8ffeo=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  pythonImportsCheck = [ "mdformat_footnote" ];

  meta = with lib; {
    description = "Footnote format addition for mdformat";
    homepage = "https://github.com/executablebooks/mdformat-footnote";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
