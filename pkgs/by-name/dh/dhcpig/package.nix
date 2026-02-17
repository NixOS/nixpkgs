{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "dhcpig";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kamorin";
    repo = "DHCPig";
    tag = finalAttrs.version;
    hash = "sha256-MquLChDuJe3DdkxxKV4W0o49IIt7Am+yuhdOqUqexS8=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    scapy
  ];

  installPhase = ''
    install -Dm755 pig.py $out/bin/dhcpig
  '';

  meta = {
    description = "Tool to perform advanced DHCP exhaustion attack";
    homepage = "https://github.com/kamorin/DHCPig";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "dhcpig";
  };
})
