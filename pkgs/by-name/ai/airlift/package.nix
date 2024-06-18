{ lib
, python3
, fetchPypi
, kubernetes-helm
, kind
, docker
}:

python3.pkgs.buildPythonApplication rec {

  pname = "airlift";
  pyproject = true;
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JcW2FXl+SrdveRmG5bD1ttf6F3LwvGZQF4ZCTpDpPa8=";
  };

  postPatch = ''
    sed -i '/argparse/d' pyproject.toml
  '';

  pythonRelaxDeps = [
    "hiyapyco"
  ];

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.pythonRelaxDepsHook
  ];

  buildInputs = [
    kubernetes-helm
    kind
    docker
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
    description = "Flexible, configuration driven CLI for Apache Airflow local development";
    homepage = "https://github.com/jl178/airlift";
    license = licenses.mit;
    changelog = "https://github.com/jl178/airlift/releases/tag/v${version}";
    maintainers = with maintainers; [ jl178 ];
    mainProgram = "airlift";
  };
}
