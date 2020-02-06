{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.43.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1qg9xyjf27dp0810h4kdliyfb8r3kvi37lq8r93d01xwfphdzs05";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
  ] ++ (with pythonPackages; [
    configobj
    requests
    tornado_4
  ]);

  # no tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jaedb/Iris;
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
