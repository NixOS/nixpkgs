{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-iris-${version}";
  version = "3.11.0";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    sha256 = "1a9pn35vv1b9v0s30ajjg7gjjvcfjwgfyp7z61m567nv6cr37vhq";
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
