{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fritz-exporter";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdreker";
    repo = "fritz_exporter";
    rev = "fritzexporter-v${version}";
    hash = "sha256-x5WCVDIKdreQCmVpiWbmVBNo42P5kSxX9dLMBKfZTWc=";
  };

  postPatch = ''
    # don't test coverage
    sed -i "/^addopts/d" pyproject.toml
  '';

  pythonRelaxDeps = [
    "defusedxml"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    defusedxml
    fritzconnection
    prometheus-client
    pyyaml
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pdreker/fritz_exporter/blob/${src.rev}/CHANGELOG.md";
    description = "Prometheus exporter for Fritz!Box home routers";
    homepage = "https://github.com/pdreker/fritz_exporter";
    license = lib.licenses.asl20;
    mainProgram = "fritzexporter";
    maintainers = with lib.maintainers; [ marie ];
  };
}
