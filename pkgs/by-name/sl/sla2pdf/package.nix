{
  lib,
  python3,
  fetchFromGitHub,
  scribus,
}:

python3.pkgs.buildPythonApplication {
  pname = "sla2pdf";
  version = "0.0.1-unstable-2023-05-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sla2pdf-team";
    repo = "sla2pdf";
    rev = "1524e6ca490da71eb201ff13bf32ef7206b0e4ef";
    hash = "sha256-mvZ6Es8TLJmNwdacRJ3Gw5z0nI6xW1igz50yjIFBUds=";
  };

  build-system = [ python3.pkgs.setuptools ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ scribus ]}"
  ];

  meta = {
    description = "Convert Scribus SLA files to PDF from the command line";
    homepage = "https://github.com/sla2pdf-team/sla2pdf";
    license = with lib.licenses; [
      cc-by-40
      mpl20
    ];
    maintainers = with lib.maintainers; [ ob7 ];
    mainProgram = "sla2pdf";
  };
}
