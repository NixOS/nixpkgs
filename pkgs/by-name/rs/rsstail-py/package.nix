{
  lib,
  python3,
  fetchPypi,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "rsstail-py";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "rsstail";
    inherit version;
    hash = "sha256-nAqk8qomG02SVq2cbQAO0MidGbxCHCk2kPNB+7YgGOQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ feedparser ];

  meta = {
    description = "Command-line syndication feed monitor";
    mainProgram = "rsstail";
    homepage = "https://github.com/gvalkov/rsstail.py";
    changelog = "https://github.com/gvalkov/rsstail.py/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zoriya ];
  };
}
