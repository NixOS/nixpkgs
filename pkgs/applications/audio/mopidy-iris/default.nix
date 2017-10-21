{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-iris-${version}";
  version = "3.4.9";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    sha256 = "0acr8ss5d0jgcy1qsjb12h0n6kr6qdp9zrbbk9vv3m3s6kcm8vgb";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
    pythonPackages.configobj
    pythonPackages.pylast
    pythonPackages.spotipy
    pythonPackages.raven
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jaedb/Iris;
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
