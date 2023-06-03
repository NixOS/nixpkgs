{ lib
, buildPythonApplication
, fetchPypi
, pynput
, xdg-base-dirs
}:

buildPythonApplication rec {
  pname = "bitwarden-menu";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OC+MHEiUU6bDT2wSSDtu0KnwDwBpbLTBta0xjfuzlOI=";
  };

  postPatch = ''
    substituteInPlace bwm/__init__.py \
      --replace 'from xdg import' 'from xdg_base_dirs import'
    substituteInPlace setup.py \
      --replace '"xdg"' '"xdg-base-dirs"'
  '';

  propagatedBuildInputs = [
    pynput
    xdg-base-dirs
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/firecat53/bitwarden-menu/releases/tag/v${version}";
    description = "Dmenu/Rofi frontend for managing Bitwarden vaults. Uses the Bitwarden CLI tool to interact with the Bitwarden database.";
    homepage = "https://github.com/firecat53/bitwarden-menu";
    license = licenses.mit;
    maintainers = [ maintainers.rodrgz ];
  };
}
