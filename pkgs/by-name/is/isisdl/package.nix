{
  lib,
  fetchPypi,
  python3Packages,
  util-linux,
}:
python3Packages.buildPythonApplication rec {
  pname = "isisdl";
  version = "1.3.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s0vGCJVSa6hf6/sIhzmaxpziP4izoRwcZfxvm//5inY=";
  };

  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    cryptography
    requests
    pyyaml
    packaging
    colorama
    pyinotify
    distro
    psutil
  ];

  pythonRelaxDeps = [
    "cryptography"
    "requests"
    "packaging"
    "distro"
    "psutil"
  ];

  buildInputs = [
    util-linux # for runtime dependency `lsblk`
  ];

  # disable tests since they require valid login credentials
  doCheck = false;

  meta = {
    homepage = "https://github.com/Emily3403/isisdl";
    description = "Downloader for ISIS of TU-Berlin";
    longDescription = ''
      A downloading utility for ISIS of TU-Berlin.
      Download all your files and videos from ISIS.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bchmnn ];
    mainProgram = "isisdl";
    platforms = lib.platforms.linux;
  };
}
