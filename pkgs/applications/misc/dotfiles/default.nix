{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "dotfiles";
  version = "0.6.4";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-m3uJeKtlCEqgN2i+y1cMchE9EKqav4U1ABCLnKrREQ8=";
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
