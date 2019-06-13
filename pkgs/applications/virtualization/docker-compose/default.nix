{ stdenv, buildPythonApplication, fetchPypi, pythonOlder
, mock, pytest, nose
, pyyaml, backports_ssl_match_hostname, colorama, docopt
, dockerpty, docker, ipaddress, jsonschema, requests
, six, texttable, websocket_client, cached-property
, enum34, functools32, paramiko
}:
buildPythonApplication rec {
  version = "1.24.0";
  pname = "docker-compose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sd3bwmz80a2rffviq9vvyxic41ya08yj41k8x1m4vv74wcab0jm";
  };

  # lots of networking and other fails
  doCheck = false;
  checkInputs = [ mock pytest nose ];
  propagatedBuildInputs = [
    pyyaml backports_ssl_match_hostname colorama dockerpty docker
    ipaddress jsonschema requests six texttable websocket_client
    docopt cached-property paramiko
  ] ++
    stdenv.lib.optional (pythonOlder "3.4") enum34 ++
    stdenv.lib.optional (pythonOlder "3.2") functools32;

  postPatch = ''
    # Remove upper bound on requires, see also
    # https://github.com/docker/compose/issues/4431
    sed -i "s/, < .*',$/',/" setup.py
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions/
    cp contrib/completion/bash/docker-compose $out/share/bash-completion/completions/docker-compose
  '';

  meta = with stdenv.lib; {
    homepage = https://docs.docker.com/compose/;
    description = "Multi-container orchestration for Docker";
    license = licenses.asl20;
    maintainers = with maintainers; [
    ];
  };
}
