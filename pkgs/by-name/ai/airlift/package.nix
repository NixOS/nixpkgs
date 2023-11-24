{ lib
, python3
, fetchPypi
, argparse
, kubernetes-helm
, kind
, docker
}:

python3.pkgs.buildPythonApplication rec {

  pname = "airlift";
  pyproject = true;
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1LE3fpfX4NExJdUdSjt4BXvxQTLJ8zrRkGHkxo/6Pb8=";
  };
  buildInputs = [
    kubernetes-helm
    kind
    docker
  ];
  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];
  propagatedBuildInputs = with python3.pkgs; [
    argparse
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
  meta = with lib; {
    description = "A flexible, configuration driven CLI for Apache Airflow local development";
    homepage = "https://github.com/jl178/airlift";
    license = licenses.mit;
    changelog = "https://github.com/jl178/airlift/releases/tag/v${version}";
    maintainers = with maintainers; [ jl178 ];
    mainProgram = "airlift";
  };
}
