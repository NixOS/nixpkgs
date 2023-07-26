{ lib
, stdenv
, fetchFromGitHub
, pythonRelaxDepsHook
, python3
, snagboot
, testers
, gitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snagboot";
  version = "1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bootlin";
    repo = "snagboot";
    rev = "v${version}";
    hash = "sha256-MU6LzjH6s2MS7T3u1OUeJ5ZmWgL0otA/q0ylwTNH4fA=";
  };

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
    hid
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

  meta = {
    homepage = "https://github.com/bootlin/snagboot";
    description = "Generic recovery and reflashing tool for embedded platforms";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
