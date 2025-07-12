{
  lib,
  python3,
  fetchFromGitHub,

  # tests
  fluxvis,
  fetchurl,
  runCommand,
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

  # FIXME: should use the drv itself (via finalAttrs) but this doesn't seem to work with buildPyApp
  passthru.tests.galactix = let
    floppyImage = fetchurl {
      url = "https://archive.org/download/galactix_202209/Galactix_d2.scp";
      hash = "sha256-9Y8okEPMcqwBOKmue4b9Qg90BTD/rrXIDhmhs6yRc5Y=";
    };
  in runCommand "galactix.png" { preferLocalBuild = true; } ''
    ${lib.getExe fluxvis} --tracks 40 write ${floppyImage} $out
  '';

  meta = {
    description = "A magnetic flux visualizer for Greazeweazle-compatible floppy images";
    homepage = "https://github.com/adafruit/fluxvis/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
    mainProgram = "fluxvis";
  };
}
