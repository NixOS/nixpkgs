{ lib, buildPythonApplication, fetchFromGitHub, configargparse, setuptools, poetry-core, rbw }:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = "refs/tags/${version}";
    hash = "sha256-5K6tofC1bIxxNOQ0jk6NbVoaGGyQImYiUZAaAmkwiTA=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = [ configargparse ];

  pythonImportsCheck = [ "rofi_rbw" ];

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ rbw ]})
  '';

  meta = with lib; {
    description = "Rofi frontend for Bitwarden";
    homepage = "https://github.com/fdw/rofi-rbw";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa dit7ya ];
    platforms = platforms.linux;
  };
}
