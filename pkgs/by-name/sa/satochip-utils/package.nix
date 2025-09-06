{
  lib,
  python3Packages,
  fetchFromGitHub,
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

  nativeCheckInputs = [ ];

  pythonRelaxDeps = [
    "pillow"
    "pysatochip"
    "pyscard"
    "pycryptotools"
    "mnemonic"
  ];

  postInstall = ''
    # Install all source files to $out/lib/satochip-utils so that imports work
    mkdir -p $out/lib/satochip-utils
    cp -r * $out/lib/satochip-utils/

    # Create a wrapper script that runs satochip_utils.py as a module
    mkdir -p $out/bin
    makeWrapper ${python3Packages.python.interpreter} $out/bin/satochip-utils \
      --set PYTHONPATH "$out/lib/satochip-utils:$PYTHONPATH" \
      --add-flags "-m satochip_utils"
  '';

  meta = {
    description = "GUI tool to configure your Satochip/Satodime/Seedkeeper card";
    homepage = "https://github.com/Toporin/Satochip-Utils";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
