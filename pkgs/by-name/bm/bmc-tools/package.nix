{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "bmc-tools";
  version = "3.0.4-unstable-2025-01-21";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ANSSI-FR";
    repo = "bmc-tools";
    rev = "94037ce01ceb651a10b04e3275b53face69f9e03";
    hash = "sha256-4sW/vSPsx+MIpUV1/V7kseTkGJqiDlCo3G1omOxKHJk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 bmc-tools.py $out/bin/bmc-tools

    runHook postInstall
  '';

  meta = {
    description = "RDP Bitmap Cache parser";
    homepage = "https://github.com/ANSSI-FR/bmc-tools";
    license = lib.licenses.cecill21;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "bmc-tools";
  };
}
