{ stdenv, buildPythonApplication, fetchPypi, pythonOlder
, installShellFiles
, mock, pytest, nose
, pyyaml, backports_ssl_match_hostname, colorama, docopt
, dockerpty, docker, ipaddress, jsonschema, requests
, six, texttable, websocket_client, cached-property
, enum34, functools32, paramiko, distro, python-dotenv
}:

buildPythonApplication rec {
  version = "1.27.4";
  pname = "docker-compose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a5690f24c27d4b43dcbe6b3fae91ba680713208e99ee863352b3bae37bcaa83";
  };

  # lots of networking and other fails
  doCheck = false;
  nativeBuildInputs = [ installShellFiles ];
  checkInputs = [ mock pytest nose ];
  propagatedBuildInputs = [
    pyyaml backports_ssl_match_hostname colorama dockerpty docker
    ipaddress jsonschema requests six texttable websocket_client
    docopt cached-property paramiko distro python-dotenv
  ] ++
    stdenv.lib.optional (pythonOlder "3.4") enum34 ++
    stdenv.lib.optional (pythonOlder "3.2") functools32;

  postPatch = ''
    # Remove upper bound on requires, see also
    # https://github.com/docker/compose/issues/4431
    sed -i "s/, < .*',$/',/" setup.py
  '';

  postInstall = ''
    installShellCompletion --bash contrib/completion/bash/docker-compose
    installShellCompletion --zsh contrib/completion/zsh/_docker-compose
  '';

  meta = with stdenv.lib; {
    homepage = "https://docs.docker.com/compose/";
    description = "Multi-container orchestration for Docker";
    license = licenses.asl20;
    maintainers = with maintainers; [ Frostman ];
  };
}
