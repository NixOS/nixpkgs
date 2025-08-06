{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "log4shell-detector";
  version = "0-unstable-2021-12-16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "log4shell-detector";
    rev = "622b88e7ea36819da23ce6ac090785cd6cca77f9";
    sha256 = "sha256-N81x9hq473LfM+bQIQLWizCAsVc/pzyB84PV7/N5jk4=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    zstandard
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  installPhase = ''
    runHook preInstall
    install -vD log4shell-detector.py $out/bin/log4shell-detector
    install -vd $out/${python3.sitePackages}/
    cp -R Log4ShellDetector $out/${python3.sitePackages}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Detector for Log4Shell exploitation attempts";
    homepage = "https://github.com/Neo23x0/log4shell-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "log4shell-detector";
  };
}
