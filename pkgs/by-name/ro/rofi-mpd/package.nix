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
    hash = "sha256-jx4srja5i+a2mnjj0W3DFPythubdACUsZB5B/Iz1S0k=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    mutagen
    python-mpd2
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
