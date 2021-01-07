{ stdenv, fetchgit, buildPythonPackage
, python
, srht, pyyaml, PyGithub }:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.14.9";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    rev = version;
    sha256 = "JUffuJTKY4I8CrJc8tJWL+CbJCZtiqtUSO9SgYoeux0=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
    PyGithub
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://dispatch.sr.ht/~sircmpwn/dispatch.sr.ht";
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
