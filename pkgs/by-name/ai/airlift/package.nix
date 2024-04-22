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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EAt3xxr9jtMaOugAV+ySjhorO8SrhBn00PZ84ZG80oI=";
  };

  postPatch = ''
    sed -i '/argparse/d' pyproject.toml
  '';

   nativeBuildInputs = [
    python3.pkgs.poetry-core
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
    description = "A flexible, configuration driven CLI for Apache Airflow local development";
    homepage = "https://github.com/jl178/airlift";
    license = licenses.mit;
    changelog = "https://github.com/jl178/airlift/releases/tag/v${version}";
    maintainers = with maintainers; [ jl178 ];
    mainProgram = "airlift";
  };
}
