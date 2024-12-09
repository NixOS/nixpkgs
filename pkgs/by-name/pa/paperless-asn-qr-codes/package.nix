{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "paperless-asn-qr-codes";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entropia";
    repo = "paperless-asn-qr-codes";
    rev = "v${version}";
    hash = "sha256-/xCU6xDrmhkua4Iw/BCzhOuqO5GT/0rTJ+Y59wuMz6E=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "\"argparse\"," ""
  '';

  nativeBuildInputs = [
    python3.pkgs.hatch-vcs
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    reportlab
    reportlab-qrcode
  ];

  pythonImportsCheck = [ "paperless_asn_qr_codes" ];

  meta = with lib; {
    description = "Command line utility for generating ASN labels for paperless with both a human-readable representation, as well as a QR code for machine consumption";
    homepage = "https://github.com/entropia/paperless-asn-qr-codes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xanderio ];
    mainProgram = "paperless-asn-qr-codes";
  };
}
