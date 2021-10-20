{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.59.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0llvn0khl07ni34jvb3a1r6rnkf0ljizhpqrs5bdishfhpwyhm0j";
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
