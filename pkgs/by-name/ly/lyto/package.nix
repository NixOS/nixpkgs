{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lyto";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eeriemyxi";
    repo = "lyto";
    tag = "v${version}";
    hash = "sha256-XCAM7vo4EcbIxFddggeqABru4epE2jW2YpF++I0mpdU=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    qrcode
    rich
    sixel
    zeroconf
  ];

  pythonImportsCheck = [
    "lyto"
  ];

  meta = {
    description = "Automatic wireless ADB connection using QR codes";
    homepage = "https://github.com/eeriemyxi/lyto";
    changelog = "https://github.com/eeriemyxi/lyto/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "lyto";
  };
}
