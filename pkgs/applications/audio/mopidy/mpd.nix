{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-MPD";
  version = "3.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0prjli4352521igcsfcgmk97jmzgbfy4ik8hnli37wgvv252wiac";
  };

  propagatedBuildInputs = [mopidy];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_mpd" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mopidy/mopidy-mpd";
    description = "Mopidy extension for controlling playback from MPD clients";
    license = licenses.asl20;
    maintainers = [ maintainers.tomahna ];
  };
}
