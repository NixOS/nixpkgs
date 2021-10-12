{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-MPD";
  version = "3.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-oZvKr61lyu7CmXP2A/xtYng1FIUPyveVJMqUuv6UnaM=";
  };

  propagatedBuildInputs = [mopidy];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_mpd" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-mpd";
    description = "Mopidy extension for controlling playback from MPD clients";
    license = licenses.asl20;
    maintainers = [ maintainers.tomahna ];
  };
}
