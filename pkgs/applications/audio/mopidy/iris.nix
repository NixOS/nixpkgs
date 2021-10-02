{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.58.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1cni9dd1c97bp92crjhsbwml12z8i6wkmj79zz8qvk46k8ixy3vp";
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
