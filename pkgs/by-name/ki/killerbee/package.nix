{
  lib,
  fetchFromGitHub,
  libgcrypt,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "killerbee";
  version = "3.0.0-beta.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "riverloopsec";
    repo = "killerbee";
    rev = "refs/tags/${version}";
    hash = "sha256-WM0Z6sd8S71F8FfhhoUq3MSD/2uvRTY/FsBP7VGGtb0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  buildInputs = with python3.pkgs; [ libgcrypt ];

  dependencies = with python3.pkgs; [
    pyserial
    pyusb
    rangeparser
    scapy
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "killerbee" ];

  meta = {
    description = "IEEE 802.15.4/ZigBee Security Research Toolkit";
    homepage = "https://github.com/riverloopsec/killerbee";
    changelog = "https://github.com/riverloopsec/killerbee/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
