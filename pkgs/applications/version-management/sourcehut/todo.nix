{ stdenv, fetchgit, buildPythonPackage
, python
, srht, redis, alembic, pystache }:

buildPythonPackage rec {
  pname = "todosrht";
  version = "0.51.11";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/todo.sr.ht";
    rev = version;
    sha256 = "0x4aray1dappalmn2f4wqrhpa5k1idccnafbfhsnfi6nj718i33a";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    alembic
    pystache
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  # Tests require a network connection
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://todo.sr.ht/~sircmpwn/todo.sr.ht;
    description = "Ticket tracking service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
