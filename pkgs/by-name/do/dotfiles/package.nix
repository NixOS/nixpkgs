{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "dotfiles";
  version = "0.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-fke8lNjyYts6cIrONAFd5r2wAlpWqJhd+usFAPCO5J4=";
  };

  # No tests in archive
  doCheck = false;

  nativeCheckInputs = with python3Packages; [ pytest ];
  propagatedBuildInputs = with python3Packages; [ click ];

  meta = with lib; {
    description = "Easily manage your dotfiles";
    mainProgram = "dotfiles";
    homepage = "https://github.com/jbernard/dotfiles";
    license = licenses.isc;
  };
}
