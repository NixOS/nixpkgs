{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "rofi-mpd";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "Rofi_MPD";
    rev = "v${version}";
    sha256 = "0jabyn6gqh8ychn2a06xws3avz0lqdnx3qvqkavfd2xr6sp2q7lg";
  };

  propagatedBuildInputs = with python3Packages; [
    mutagen
    mpd2
    toml
    appdirs
  ];

  # upstream doesn't contain a test suite
  doCheck = false;

  meta = with lib; {
    description = "Rofi menu for interacting with MPD written in Python";
    mainProgram = "rofi-mpd";
    homepage = "https://github.com/JakeStanger/Rofi_MPD";
    license = licenses.mit;
    maintainers = with maintainers; [ jakestanger ];
    platforms = platforms.all;
  };
}
