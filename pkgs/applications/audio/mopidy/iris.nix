{ lib, python3Packages, fetchPypi, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.64.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "062x73glhn1x4wgc7zmb9y3cq15d5grgqf5drdpbp6p3cgk4s2vc";
  };

  propagatedBuildInputs = [
    mopidy
  ] ++ (with python3Packages; [
    configobj
    requests
    tornado
  ]);

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
