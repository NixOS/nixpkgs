{ lib, python3Packages, fetchPypi, dbus }:
python3Packages.buildPythonApplication rec {
  pname = "spotify-cli-linux";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0slyc3jfrj3rwq8rv6p5aqkw487aw7a87kmf1fb6n4vnvcf08v7w";
  };

  preBuild = ''
    substituteInPlace spotifycli/spotifycli.py \
      --replace dbus-send ${dbus}/bin/dbus-send
  '';

  disabled = !python3Packages.isPy3k;
  propagatedBuildInputs = with python3Packages; [ lyricwikia dbus-python ];

  # upstream has no code tests, but uses its "tests" for linting and formatting checks
  doCheck = false;

  meta = with lib; {
    homepage = "https://pwittchen.github.io/spotify-cli-linux/";
    maintainers = [ maintainers.kmein ];
    description = "A command line interface to Spotify on Linux.";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
