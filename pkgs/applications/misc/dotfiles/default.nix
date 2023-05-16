<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "dotfiles";
  version = "0.6.4";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version pname;
    sha256 = "03qis6m9r2qh00sqbgwsm883s4bj1ibwpgk86yh4l235mdw8jywv";
  };

  # No tests in archive
  doCheck = false;

  nativeCheckInputs = with python3Packages; [ pytest ];
  propagatedBuildInputs = with python3Packages; [ click ];

  meta = with lib; {
    description = "Easily manage your dotfiles";
    homepage = "https://github.com/jbernard/dotfiles";
    license = licenses.isc;
  };
}
