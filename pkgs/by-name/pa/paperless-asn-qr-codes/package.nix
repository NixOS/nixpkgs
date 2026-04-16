{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "paperless-asn-qr-codes";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entropia";
    repo = "paperless-asn-qr-codes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mCymgzKjLMrwb1AjkfFf1EHTkW1G0y+R3ZbG/6Xd978=";
  };

  build-system = [
    python3.pkgs.hatch-vcs
    python3.pkgs.hatchling
  ];

  pythonRelaxDeps = [
    "reportlab"
  ];

  dependencies = with python3.pkgs; [
    reportlab
    reportlab-qrcode
  ];

  pythonImportsCheck = [ "paperless_asn_qr_codes" ];

  meta = {
    changelog = "https://codeberg.org/entropia/paperless-asn-qr-codes/releases/tag/${finalAttrs.src.tag}";
    description = "Command line utility for generating ASN labels for paperless with both a human-readable representation, as well as a QR code for machine consumption";
    homepage = "https://github.com/entropia/paperless-asn-qr-codes";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "paperless-asn-qr-codes";
  };
})
