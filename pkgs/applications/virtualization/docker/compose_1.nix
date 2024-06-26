{
  lib,
  buildPythonApplication,
  fetchPypi,
  installShellFiles,
  mock,
  pytest,
  nose,
  pyyaml,
  colorama,
  docopt,
  dockerpty,
  docker,
  jsonschema,
  requests,
  six,
  texttable,
  websocket-client,
  cached-property,
  paramiko,
  distro,
  python-dotenv,
}:

buildPythonApplication rec {
  version = "1.29.2";
  pname = "docker-compose";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TIzZ0h0jdBJ5PRi9MxEASe6a+Nqz/iwhO70HM5WbCbc=";
  };

  # lots of networking and other fails
  doCheck = false;
  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [
    mock
    pytest
    nose
  ];
  propagatedBuildInputs = [
    pyyaml
    colorama
    dockerpty
    docker
    jsonschema
    requests
    six
    texttable
    websocket-client
    docopt
    cached-property
    paramiko
    distro
    python-dotenv
  ];

  postPatch = ''
    # Remove upper bound on requires, see also
    # https://github.com/docker/compose/issues/4431
    sed -i "s/, < .*',$/',/" setup.py
  '';

  postInstall = ''
    installShellCompletion --bash contrib/completion/bash/docker-compose
    installShellCompletion --zsh contrib/completion/zsh/_docker-compose
  '';

  meta = with lib; {
    homepage = "https://docs.docker.com/compose/";
    description = "Multi-container orchestration for Docker";
    mainProgram = "docker-compose";
    license = licenses.asl20;
    maintainers = with maintainers; [ Frostman ];
  };
}
