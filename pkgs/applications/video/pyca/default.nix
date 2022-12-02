{ stdenv, lib, buildPythonApplication, fetchFromGitHub, pycurl, python-dateutil, configobj, sqlalchemy, sdnotify, flask }:

buildPythonApplication rec {
  pname = "pyca";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "opencast";
    repo = "pyCA";
    rev = "v${version}";
    sha256 = "0cvkmdlcax9da9iw4ls73vw0pxvm8wvchab5gwdy9w9ibqdpcmwh";
  };

  propagatedBuildInputs = [
    pycurl
    python-dateutil
    configobj
    sqlalchemy
    sdnotify
    flask
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A fully functional Opencast capture agent written in Python";
    homepage = "https://github.com/opencast/pyCA";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ pmiddend ];
  };
}

