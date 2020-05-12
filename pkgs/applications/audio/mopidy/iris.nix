{ stdenv, python3Packages, mopidy, mopidy-local-images }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.47.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1lvq5qsnn2djwkgbadzr7rr6ik2xh8yyj0p3y3hck9pl96ms7lfv";
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
