{
  lib,
  buildPythonApplication,
  pythonOlder,
  fetchFromGitHub,
  protonvpn-nm-lib,
  pythondialog,
  dialog,
}:

buildPythonApplication rec {
  pname = "protonvpn-cli";
  version = "3.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "protonvpn";
    repo = "linux-cli";
    rev = "refs/tags/${version}";
    sha256 = "sha256-KhfogC23i7THe6YZJ6Sy1+q83vZupHsS69NurHCeo8I=";
  };

  propagatedBuildInputs = [
    protonvpn-nm-lib
    pythondialog
    dialog
  ];

  # Project has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Linux command-line client for ProtonVPN";
    homepage = "https://github.com/protonvpn/linux-cli";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "protonvpn-cli";
  };
}
