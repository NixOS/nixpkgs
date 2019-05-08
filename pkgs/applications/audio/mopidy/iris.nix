{ stdenv, python2Packages, mopidy, mopidy-local-images }:

python2Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.37.1";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "0qcg456k7av0anymmmnlcn0v4642gbgk0nhic6w9bg9v5m0nj9ll";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
  ] ++ (with python2Packages; [
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
