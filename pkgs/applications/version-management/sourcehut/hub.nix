{ stdenv, fetchgit, buildPythonPackage
, python
, srht }:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.11.5";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    rev = version;
    sha256 = "0cysdfy1z69jaizblbq0ywpcvcnx57rlzg42k98kd9w2mqzj5173";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
