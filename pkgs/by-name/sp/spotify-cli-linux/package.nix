{
  lib,
  python3Packages,
  fetchFromGitHub,
  dbus,
}:
python3Packages.buildPythonApplication rec {
  pname = "spotify-cli-linux";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwittchen";
    repo = "spotify-cli-linux";
    tag = "v${version}";
    hash = "sha256-Ko/as7wiBHawmyag9jFZqpPUZhb3p1+oYcl+26XyBZk=";
  };

  preBuild = ''
    substituteInPlace spotifycli/spotifycli.py \
      --replace-fail dbus-send ${dbus}/bin/dbus-send
  '';

  disabled = !python3Packages.isPy3k;
  build-system = with python3Packages; [ setuptools ];
  propagatedBuildInputs = with python3Packages; [
    lyricwikia
    jeepney
  ];

  # upstream has no code tests, but uses its "tests" for linting and formatting checks
  doCheck = false;

  meta = with lib; {
    homepage = "https://pwittchen.github.io/spotify-cli-linux/";
    maintainers = [ maintainers.kmein ];
    description = "Command line interface to Spotify on Linux";
    mainProgram = "spotifycli";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
