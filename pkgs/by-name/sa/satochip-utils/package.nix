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
  version = "0.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "Satochip-Utils";
    tag = "v${version}";
    hash = "sha256-/Qx9bETVOzGljXJSFAY1iUc1OoEtcNU3rKIhOD0ZDKY=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    cbor2
    customtkinter
    mnemonic
    ndeflib
    pillow
    pycryptotools
    pyqrcode
    pysatochip
    pyscard
    tkinter
  ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  pythonRelaxDeps = [
    "mnemonic"
    "pillow"
    "pycryptotools"
    "pysatochip"
    "pyscard"
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
