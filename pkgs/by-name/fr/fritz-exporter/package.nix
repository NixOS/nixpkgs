{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fritz-exporter";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdreker";
    repo = "fritz_exporter";
    tag = "fritzexporter-v${finalAttrs.version}";
    hash = "sha256-IFTaBPv8sXeynGCr9R4ahfuGdl9wyULt0f6S6Acaqcs=";
  };

  postPatch = ''
    # don't test coverage
    sed -i "/^addopts/d" pyproject.toml
  '';

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    prometheus-client
    fritzconnection
    pyyaml
    requests
    attrs
    defusedxml
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # Required for tests
  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/pdreker/fritz_exporter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Prometheus exporter for Fritz!Box home routers";
    homepage = "https://github.com/pdreker/fritz_exporter";
    license = lib.licenses.asl20;
    mainProgram = "fritzexporter";
    maintainers = with lib.maintainers; [ marie ];
  };
})
