{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rofi-mpd";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "Rofi_MPD";
    rev = "v${finalAttrs.version}";
    sha256 = "0jabyn6gqh8ychn2a06xws3avz0lqdnx3qvqkavfd2xr6sp2q7lg";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    mutagen
    mpd2
    toml
    appdirs
  ];

  # upstream doesn't contain a test suite
  doCheck = false;

  meta = {
    description = "Rofi menu for interacting with MPD written in Python";
    mainProgram = "rofi-mpd";
    homepage = "https://github.com/JakeStanger/Rofi_MPD";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakestanger ];
    platforms = lib.platforms.all;
  };
})
