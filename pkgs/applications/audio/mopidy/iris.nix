{ stdenv, python3Packages, mopidy, mopidy-local-images }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.45.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "02jmylz76wlwxlv8drndprb7r9l8kqqgjkp17mjx5ngnl545pc2w";
  };

  propagatedBuildInputs = [
    mopidy
  ] ++ (with python3Packages; [
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
