{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.17.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "02k1br077v9c5x6nn0391vh28pvn1zjbkjv8h508vy7k6ch2xjyq";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
  ] ++ (with pythonPackages; [
    configobj
    pylast
    spotipy
    raven
    tornado
  ]);

  postPatch = "sed -i /tornado/d setup.py";

  # no tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jaedb/Iris;
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
