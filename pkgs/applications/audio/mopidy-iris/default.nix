{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-iris-${version}";
  version = "2.14.3";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    sha256 = "04vxjn0jx6im3cay54dj1bhfiac2mxn2f96lj5450h8s30ah5xz3";
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
