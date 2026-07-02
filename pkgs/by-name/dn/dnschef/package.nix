{
  python3Packages,
  fetchFromGitHub,
  lib,
}:

python3Packages.buildPythonApplication {
  pname = "dnschef";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "iphelix";
    repo = "dnschef";
    rev = "a395411ae1f5c262d0b80d06a45a445f696f3243";
    hash = "sha256-OMy89YAtAHplLm/51kzXIlz2BiGJjSsY9h/+wg2Hg1I=";
  };

  pyproject = false;
  installPhase = ''
    install -D ./dnschef.py $out/bin/dnschef
  '';

  dependencies = [ python3Packages.dnslib ];

  meta = {
    homepage = "https://github.com/iphelix/dnschef";
    description = "Highly configurable DNS proxy for penetration testers and malware analysts";
    mainProgram = "dnschef";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.gfrascadorio ];
  };
}
