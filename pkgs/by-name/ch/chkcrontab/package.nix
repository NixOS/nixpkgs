{
  lib,
  python3,
  fetchPypi,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "chkcrontab";
  version = "1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmxavjkjkvjysgf9cf5fcpk589gb75n1mn20iki82wifi1pk1jn";
  };

  meta = with lib; {
    description = "Tool to detect crontab errors";
    mainProgram = "chkcrontab";
    license = licenses.asl20;
    maintainers = [ ];
    homepage = "https://github.com/lyda/chkcrontab";
  };
}
