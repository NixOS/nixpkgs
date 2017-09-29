{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-iris-${version}";
  version = "3.4.1";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    sha256 = "04fjj2n5v53ykxnjgna1y8bvk7g3x0yiqisvzrdva693lfz9cbgx";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
    pythonPackages.configobj
    pythonPackages.pylast
    pythonPackages.spotipy
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jaedb/Iris;
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
