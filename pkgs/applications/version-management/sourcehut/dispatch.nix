{ lib
, fetchFromSourcehut
, buildPythonPackage
, srht
, pyyaml
, PyGithub
, python
}:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.15.35";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "dispatch.sr.ht";
    rev = version;
    sha256 = "sha256-X+woTUvPUBi4bldZKhxJyPT/Pj7Ho2tHxgWMcyHpuC8=";
  };

  propagatedBuildInputs = [
    srht
    pyyaml
    PyGithub
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  pythonImportsCheck = [ "dispatchsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
