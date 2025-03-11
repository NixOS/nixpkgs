{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nmap-parse";
  version = "0-unstable-2022-09-26";
  format = "other";

  src = fetchFromGitHub {
    owner = "jonny1102";
    repo = "nmap-parse";
    # https://github.com/jonny1102/nmap-parse/issues/12
    rev = "ae270ac9ce05bfbe822dbbb29411adf562d40abf";
    hash = "sha256-iaE4a5blbDPaKPRnR46+AfegXOEW88i+z/VIVGCepeM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    cmd2
    colorama
    ipy
    tabulate
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 "nmap-parse.py" "$out/bin/nmap-parse"

    install -vd $out/${python3.sitePackages}/
    cp -R modules $out/${python3.sitePackages}

    runHook postInstall
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Command line nmap XML parser";
    homepage = "https://github.com/jonny1102/nmap-parse";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nmap-parse";
  };
}
