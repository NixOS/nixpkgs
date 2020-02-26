{ stdenv, python3Packages, mopidy, mopidy-local-images }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.44.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0gap0cyw6sfb4487i1x220rr9fbsz6xyw68l15ar0vfll0zv0760";
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
