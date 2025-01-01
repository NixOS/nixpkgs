{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "avell-unofficial-control-center";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "rodgomesc";
    repo = "avell-unofficial-control-center";
    # https://github.com/rodgomesc/avell-unofficial-control-center/issues/58
    rev = "e32e243e31223682a95a719bc58141990eef35e6";
    sha256 = "1qz1kv7p09nxffndzz9jlkzpfx26ppz66f8603zyamjq9dqdmdin";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    pyusb
    elevate
  ];

  meta = with lib; {
    homepage = "https://github.com/rodgomesc/avell-unofficial-control-center";
    description = "Software for controlling RGB keyboard lights on some gaming laptops that use ITE Device(8291) Rev 0.03";
    mainProgram = "aucc";
    license = licenses.mit;
    maintainers = with maintainers; [ rkitover ];
  };
}
