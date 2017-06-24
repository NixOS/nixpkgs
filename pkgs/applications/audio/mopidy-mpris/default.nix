{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-mpris-${version}";

  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-mpris";
    rev = "v${version}";
    sha256 = "0adpfnphn5px7wcbv9z5nxwhaq0hj4khzv1vkmv5g3ag9c6cv01l";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.pykka
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mopidy/mopidy-mpris";
    description = "Mopidy extension for controlling Mopidy through the MPRIS D-Bus interface";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
