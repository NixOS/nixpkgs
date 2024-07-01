{ lib
, fetchPypi
, python3Packages
, util-linux
, withFFmpeg ? false, ffmpeg
}:
python3Packages.buildPythonApplication rec {
  pname = "isisdl";
  version = "1.3.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s0vGCJVSa6hf6/sIhzmaxpziP4izoRwcZfxvm//5inY=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

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
  ];

  buildInputs = [
    util-linux # for runtime dependency `lsblk`
  ] ++ lib.optionals withFFmpeg [
    ffmpeg
  ];

  # disable tests since they require valid login credentials
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Emily3403/isisdl";
    description = "A downloader for ISIS of TU-Berlin";
    longDescription = ''
      A downloading utility for ISIS of TU-Berlin.
      Download all your files and videos from ISIS.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ bchmnn ];
    mainProgram = "isisdl";
    platforms = platforms.linux;
  };
}
