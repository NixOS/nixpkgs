{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cp210x-program";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "VCTLabs";
    repo = "cp210x-program";
    rev = "refs/tags/${version}";
    sha256 = "sha256-IjKshP12WfFly9cPm6svD4qZW6cT8C7lOVrGenSqbfY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    hexdump
    pyusb
  ];

  postInstall = ''
    ln -s $out/bin/cp210x-program{.py,}
  '';

  meta = with lib; {
    description = "EEPROM tool for Silabs CP210x USB-Serial adapter";
    homepage = "https://github.com/VCTLabs/cp210x-program";
    license = licenses.lgpl21Only; # plus/only status unclear
    maintainers = [ ];
    mainProgram = "cp210x-program";
  };
}
