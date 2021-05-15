{ lib, buildPythonApplication, fetchPypi, pythonOlder
, installShellFiles
, mock, pytest, nose
, pyyaml, backports_ssl_match_hostname, colorama, docopt
, dockerpty, docker, ipaddress, jsonschema, requests
, six, texttable, websocket_client, cached-property
, enum34, functools32, paramiko, distro, python-dotenv
}:

buildPythonApplication rec {
  version = "1.28.6";
  pname = "docker-compose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d44906f7ab738ba2d1785130ed31b16111eee6dc5a1dbd7252091dae48c5281";
  };

  # lots of networking and other fails
  doCheck = false;
  nativeBuildInputs = [ installShellFiles ];
  checkInputs = [ mock pytest nose ];
  propagatedBuildInputs = [
    pyyaml colorama dockerpty docker
    ipaddress jsonschema requests six texttable websocket_client
    docopt cached-property paramiko distro python-dotenv
  ] ++ lib.optional (pythonOlder "3.7") backports_ssl_match_hostname
  ++ lib.optional (pythonOlder "3.4") enum34
  ++ lib.optional (pythonOlder "3.2") functools32;

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
    license = licenses.asl20;
    maintainers = with maintainers; [ Frostman ];
  };
}
