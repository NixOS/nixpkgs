{
  fetchFromGitHub,
  fuse,
  lib,
  libusb1,
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication {
  name = "mtkclient";
  version = "2.0.1";
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "399b3a1c25e73ddf4951f12efd20f7254ee04a39";
    hash = "sha256-XNPYeVhp5P+zQdumS9IzlUd5+WebL56qcgs10WS2/LY=";
  };

  buildInputs = [
    libusb1
    fuse
  ];

  propagatedBuildInputs = with python3Packages; [
    wheel
    setuptools
    pyusb
    pycryptodome
    pycryptodomex
    colorama
    shiboken6
    pyside6
    mock
    pyserial
    flake8
    keystone-engine
    capstone
    unicorn
    keystone-engine
    fusepy
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp $src/mtkclient/Setup/Linux/*.rules $out/lib/udev/rules.d
    ln -s $out/bin/mtk $out/bin/mtkclient
  '';

  meta = {
    description = "MTK reverse engineering and flash tool.";
    homepage = "https://github.com/bkerler/mtkclient";
    license = lib.licenses.gpl3Only;
    mainProgram = "mtk";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
}
