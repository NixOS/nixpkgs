{ stdenv, buildPythonApplication, fetchPypi, pythonOlder
, mock, pytest, nose
, pyyaml, backports_ssl_match_hostname, colorama, docopt
, dockerpty, docker, ipaddress, jsonschema, requests
, six, texttable, websocket_client, cached-property
, enum34, functools32,
}:
buildPythonApplication rec {
  version = "1.23.2";
  pname = "docker-compose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x2jlh7z2znvyz2pqcpn0gigfiqnx8s59pc7xlvy9ryd76g9w1zz";
  };

  # lots of networking and other fails
  doCheck = false;
  checkInputs = [ mock pytest nose ];
  propagatedBuildInputs = [
    pyyaml backports_ssl_match_hostname colorama dockerpty docker
    ipaddress jsonschema requests six texttable websocket_client
    docopt cached-property
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
      jgeerds
    ];
  };
}
