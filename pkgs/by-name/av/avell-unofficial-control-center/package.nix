{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "avell-unofficial-control-center";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rodgomesc";
    repo = "avell-unofficial-control-center";
    # https://github.com/rodgomesc/avell-unofficial-control-center/issues/58
    rev = "e32e243e31223682a95a719bc58141990eef35e6";
    hash = "sha256-NrbacEtYVuX/AAY5Y/69RnR3/6Qy/d+sc90mcM+e4eM=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyusb
    elevate
  ];

  # No tests included
  doCheck = false;

  meta = {
    homepage = "https://github.com/rodgomesc/avell-unofficial-control-center";
    description = "Software for controlling RGB keyboard lights on some gaming laptops that use ITE Device(8291) Rev 0.03";
    mainProgram = "aucc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rkitover ];
  };
}
