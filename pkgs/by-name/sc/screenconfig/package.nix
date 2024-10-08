{
  lib,
  python3Packages,
  fetchFromGitHub,
  xrandr,
  srandrd,
  feh,
}:

python3Packages.buildPythonPackage rec {
  pname = "screenconfig";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X1Mz8UbOOW/4LM9IZoG/kbwv2G0EppTsacKapQMChkc=";
  };

  propagatedBuildInputs = [
    python3Packages.toml
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
    mainProgram = "dex";
  };
}
