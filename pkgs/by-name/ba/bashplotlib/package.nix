{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "bashplotlib";
  version = "0.6.5-unstable-2021-03-31";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "glamp";
    repo = "bashplotlib";
    rev = "db4065cfe65c0bf7c530e0e8b9328daf9593ad74";
    sha256 = "sha256-0S6mgy6k7CcqsDR1kE5xcXGidF1t061e+M+ZuP2Gk3c=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  passthru.updateScript = nix-update-script { };

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/glamp/bashplotlib";
    description = "Plotting in the terminal";
    maintainers = with lib.maintainers; [ dtzWill ];
    license = lib.licenses.mit;
  };
}
