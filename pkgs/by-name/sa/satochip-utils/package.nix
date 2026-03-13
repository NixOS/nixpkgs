{
  copyDesktopItems,
  fetchFromGitHub,
  imagemagick,
  lib,
  makeDesktopItem,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "satochip-utils";
  version = "0.4.0-beta";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "Satochip-Utils";
    tag = "v${version}";
    hash = "sha256-QOnW06sfSPN7tgsAfJYySpY4/+53x1hmxFJK/9s9Jhc=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    tkinter
    customtkinter
    pillow
    mnemonic
    pysatochip
    pillow
    pyscard
    pyqrcode
    pycryptotools
    cbor2
  ];

  pythonRelaxDeps = [
    "pillow"
    "pysatochip"
    "pyscard"
    "pycryptotools"
    "mnemonic"
    "pyperclip"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "satochip-utils";
      desktopName = "Satochip Utils";
      comment = "GUI tool to configure your Satochip/Satodime/Seedkeeper card";
      exec = "satochip-utils";
      icon = "satochip-utils";
      categories = [ "Utility" ];
      terminal = false;
    })
  ];

  postInstall = ''
    mkdir -p $out/lib/satochip-utils
    cp -r * $out/lib/satochip-utils/

    mkdir -p $out/bin
    makeWrapper ${python3Packages.python.interpreter} $out/bin/satochip-utils \
      --set PYTHONPATH "$out/lib/satochip-utils:$PYTHONPATH" \
      --add-flags "-m satochip_utils"

    for size in 16 32 48 64 128 256; do
      dir=$out/share/icons/hicolor/''${size}x''${size}/apps
      mkdir -p $dir
      convert satochip_utils.png -resize ''${size}x''${size} $dir/satochip-utils.png
    done
  '';

  meta = {
    description = "GUI tool to configure your Satochip/Satodime/Seedkeeper card";
    homepage = "https://github.com/Toporin/Satochip-Utils";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
