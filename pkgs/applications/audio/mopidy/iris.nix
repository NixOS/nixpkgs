{ stdenv, python3Packages, mopidy, mopidy-local-images }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.49.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0zddm7286iwx437gjz47m4g28s8gdcxnm2hmly9w1dzi08aa4fas";
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
    homepage = "https://github.com/jaedb/Iris";
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
