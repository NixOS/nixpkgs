{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-iris-${version}";
  version = "3.0.5";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    sha256 = "0rabpzmiis13z4qz3vqlsfc9xjkwracafckahnq2cq97qawyq9y9";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
    pythonPackages.configobj
    pythonPackages.pylast
    pythonPackages.spotipy
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
