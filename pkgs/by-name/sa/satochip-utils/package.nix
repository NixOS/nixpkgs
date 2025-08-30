{
  lib,
  python3Packages,
  python3,
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
  ];

  build-system = [ python3Packages.setuptools ];

  postInstall = ''
    # Install all source files to $out/lib/satochip-utils so that imports work
    mkdir -p $out/lib/satochip-utils
    cp -r ${src}/* $out/lib/satochip-utils/

    # Create a wrapper script that runs satochip_utils.py as a module
    mkdir -p $out/bin
    makeWrapper ${python3}/bin/python $out/bin/satochip-utils \
      --set PYTHONPATH "$out/lib/satochip-utils:$PYTHONPATH" \
      --add-flags "-m satochip_utils"
  '';

  meta = {
    changelog = "https://github.com/Toporin/Satochip-Utils/blob/master/CHANGELOG.md";
    description = "Application that unifies the functionality of Satochip card constellation";
    homepage = "https://github.com/Toporin/Satochip-Utils";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
