{
  lib,
  python3Packages,
  python3,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "Satochip-Utils";
  version = "0.3.0-beta";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "Satochip-Utils";
    tag = "v${version}";
    hash = "sha256-9IXvyhbHpiCZR3/ixpqaylAkyn5oS8cSZBq3Op0gFgo=";
  };

  propagatedBuildInputs = with python3Packages; [
    tkinter
    customtkinter
    pillow
    mnemonic
    pysatochip
    pillow
    pyscard
    pyqrcode
    pycryptotools
  ];

  pythonRelaxDeps = [
    "pillow"
    "pysatochip"
    "pyscard"
    "pycryptotools"
    "mnemonic"
  ];

  build-system = [ python3Packages.setuptools ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r ${src}/* $out/bin/
    echo '#!${python3}/bin/python' > $out/bin/${pname}
    cat ${src}/satochip_utils.py >> $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = {
    changelog = "https://github.com/Toporin/Satochip-Utils/blob/master/CHANGELOG.md";
    description = "Application that unifies the functionality of Satochip card constellation";
    homepage = "https://github.com/Toporin/Satochip-Utils";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
