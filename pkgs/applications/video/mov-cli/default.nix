{ lib
, python3
, fetchFromGitHub
, mpv
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mov-cli";
  version = "1.5.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = version;
    sha256 = "sha256-WhoP4FcoO9+O9rfpC3oDQkVIpVOqxfdLRygHgf1O01g=";
  };
  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.getBin mpv}/bin"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    poetry-core
    krfzf-py
    pycrypto
    setuptools
    httpx
    click
    beautifulsoup4
    colorama
  ];

  meta = with lib; {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "A cli tool to browse and watch movies";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ baitinq ];
    mainProgram = "mov-cli";
  };
}
