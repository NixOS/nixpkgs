{
  lib,
  python3Packages,
  fetchPypi,
  kubernetes-helm,
  kind,
  docker,
}:

python3Packages.buildPythonApplication (finalAttrs: {

  pname = "airlift";
  pyproject = true;
  version = "0.4.0";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JcW2FXl+SrdveRmG5bD1ttf6F3LwvGZQF4ZCTpDpPa8=";
  };

  postPatch = ''
    sed -i '/argparse/d' pyproject.toml
  '';

  pythonRelaxDeps = [
    "hiyapyco"
  ];

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  buildInputs = [
    kubernetes-helm
    kind
    docker
  ];

  propagatedBuildInputs = with python3Packages; [
    halo
    pyyaml
    hiyapyco
    jinja2
    dotmap
    requests
  ];
  pythonImportsCheck = [
    "airlift"
  ];
  meta = {
    description = "Flexible, configuration driven CLI for Apache Airflow local development";
    homepage = "https://github.com/jl178/airlift";
    license = lib.licenses.mit;
    changelog = "https://github.com/jl178/airlift/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jl178 ];
    mainProgram = "airlift";
  };
})
