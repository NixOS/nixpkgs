{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "bmc-tools";
  version = "3.0.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "ANSSI-FR";
    repo = "bmc-tools";
    rev = "94037ce01ceb651a10b04e3275b53face69f9e03";
    hash = "sha256-4sW/vSPsx+MIpUV1/V7kseTkGJqiDlCo3G1omOxKHJk=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bmc-tools.py $out/bin/bmc-tools
    chmod +x $out/bin/bmc-tools
  '';

  meta = {
    description = "RDP Bitmap Cache parser";
    homepage = "https://github.com/ANSSI-FR/bmc-tools";
    license = lib.licenses.cecill21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "bmc-tools";
  };
}
