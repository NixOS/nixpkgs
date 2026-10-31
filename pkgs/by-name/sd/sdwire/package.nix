{
  lib,
  fetchFromGitHub,
  python3,
  # tests
  runCommand,
  sdwire,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sdwire";
  version = "0.2.3-unstable-2025-04-24";
  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.10";
  src = fetchFromGitHub {
    owner = "badger-embedded";
    repo = "sdwire-cli";
    rev = "1fb9678eb2459dc08c4feff24d6fa9072234cd19";
    hash = "sha256-TYzgIqN595UIAXs1MrWAB8A5h/p4R38sGpcsxDDtUlk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    pyusb
    pyftdi
    pyudev
  ];

  pythonImportsCheck = [ "sdwire" ];
  passthru.tests = {
    # make sure that sdwire --help is working as expected
    help = runCommand "${pname}-test" { } ''
      ${sdwire}/bin/sdwire --help
      [ "$?" = "0" ] > $out
    '';
  };

  meta = {
    description = "CLI for Badgerd SDWire Devices";
    mainProgram = "sdwire";
    homepage = "https://github.com/Badger-Embedded/sdwire-cli";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ talhaHavadar ];
  };
}
