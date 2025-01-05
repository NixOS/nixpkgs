{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "ps_mem";
  version = "3.14";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jCfPtPSky/QFk9Xo/tq3W7609Pie1yLC4iS4dqjCa+E=";
  };

  meta = {
    description = "Utility to accurately report the in core memory usage for a program";
    homepage = "https://github.com/pixelb/ps_mem";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
    mainProgram = "ps_mem";
  };
}
