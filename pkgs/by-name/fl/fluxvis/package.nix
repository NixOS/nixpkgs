{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "fluxvis";
  version = "1.0.0.alpha.4-unstable-2024-11-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "fluxvis";
    rev = "cc567b8611af0f1110efd19b853516b00663155e";
    hash = "sha256-YySlyfN1JDNyBycATXLWxpqmNYPQH2aEQY6kJ3pjTTU=";
  };

  # Can't be handled by pythonRelaxDepsHook; clean up when #382125 lands
  prePatch = ''
    sed -i '/setuptools_scm\[toml\]/d' pyproject.toml
  '';

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    click
    numpy
    scikit-image
  ];

  pythonImportsCheck = [ "fluxvis" ];

  meta = {
    description = "A magnetic flux visualizer for Greazeweazle-compatible floppy images";
    homepage = "https://github.com/adafruit/fluxvis/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
    mainProgram = "fluxvis";
  };
}
