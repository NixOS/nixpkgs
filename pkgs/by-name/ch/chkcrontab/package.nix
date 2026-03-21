{
  lib,
  python3,
  fetchPypi,
}:

with python3.pkgs;

buildPythonApplication (finalAttrs: {
  pname = "chkcrontab";
  version = "1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0gmxavjkjkvjysgf9cf5fcpk589gb75n1mn20iki82wifi1pk1jn";
  };

  meta = {
    description = "Tool to detect crontab errors";
    mainProgram = "chkcrontab";
    license = lib.licenses.asl20;
    maintainers = [ ];
    homepage = "https://github.com/lyda/chkcrontab";
  };
})
