{
  lib,
  python3,
  fetchFromGitHub,
  xrandr,
  srandrd,
  feh,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "screenconfig";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jceb";
    repo = "screenconfig";
    tag = "v${version}";
    hash = "sha256-X1Mz8UbOOW/4LM9IZoG/kbwv2G0EppTsacKapQMChkc=";
  };
  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    toml
  ];

  propagatedBuildInputs = [
    xrandr
    srandrd
    feh
  ];

  meta = {
    description = "Automatic configuration of connected screens/monitors";
    homepage = "https://github.com/jceb/screenconfig";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jceb ];
    mainProgram = "screenconfig";
  };
}
