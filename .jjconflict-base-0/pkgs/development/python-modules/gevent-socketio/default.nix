{
  lib,
  buildPythonPackage,
  fetchPypi,
  gevent,
  gevent-websocket,
  versiontools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gevent-socketio";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UzlKuT+9hNnbuyvvhTSfalA7/FPYapvoZTJQ8aBBKv8=";
  };

  nativeBuildInputs = [ versiontools ];

  buildInputs = [ gevent-websocket ];

  propagatedBuildInputs = [ gevent ];

  # Tests are not ported to Python 3
  doCheck = false;

  pythonImportsCheck = [ "socketio" ];

  meta = with lib; {
    description = "SocketIO server based on the Gevent pywsgi server";
    homepage = "https://github.com/abourget/gevent-socketio";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
