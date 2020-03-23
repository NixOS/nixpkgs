{ stdenv, python3Packages, mopidy, mopidy-local-images }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.46.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0c7b6zbcj4bq5qsxvhjwqclrl1k2hs3wb50pfjbw7gs7m3gm2b7d";
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
