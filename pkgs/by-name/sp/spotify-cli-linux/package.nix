{
  lib,
  python3Packages,
  fetchFromGitHub,
  dbus,
}:
python3Packages.buildPythonApplication rec {
  pname = "spotify-cli-linux";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwittchen";
    repo = "spotify-cli-linux";
    tag = "v${version}";
    hash = "sha256-GEAEtS9YVZDeOn7+oxbAz6ICO7XL0sDOkbPdUD+gm04=";
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
