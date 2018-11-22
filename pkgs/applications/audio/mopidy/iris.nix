{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.29.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1v767a2j6lzp5yppfjna0ifv8psj60pphzd7njcdkx71dvpswpi2";
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
