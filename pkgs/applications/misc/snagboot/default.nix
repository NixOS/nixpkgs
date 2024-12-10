{
  lib,
  stdenv,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  python3,
  snagboot,
  testers,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snagboot";
  version = "1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bootlin";
    repo = "snagboot";
    rev = "v${version}";
    hash = "sha256-ergTa6uR1SyR27H2HAWp/rtgalCnQge07Pi24PrsW+8=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "pylibfdt"
    "swig"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    pyusb
    pyserial
    crccheck
    six
    xmodem
    pyyaml
    libfdt
    tftpy
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    rules="src/snagrecover/50-snagboot.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi

    mkdir -p "$out/lib/udev/rules.d"
    cp "$rules" "$out/lib/udev/rules.d/50-snagboot.rules"
  '';

  # There are no tests
  doCheck = false;

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };

    tests.version = testers.testVersion {
      package = snagboot;
      command = "snagrecover --version";
      version = "v${version}";
    };
  };

  meta = {
    homepage = "https://github.com/bootlin/snagboot";
    description = "Generic recovery and reflashing tool for embedded platforms";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
