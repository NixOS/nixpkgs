{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "log4jcheck";
  version = "0-unstable-2021-12-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "NorthwaveSecurity";
    repo = "log4jcheck";
    rev = "736f1f4044e8a9b7bf5db515e2d1b819253f0f6d";
    sha256 = "sha256-1al7EMYbE/hFXKV4mYZlkEWTUIKYxgXYU3qBLlczYvs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  installPhase = ''
    runHook preInstall
    install -vD nw_log4jcheck.py $out/bin/log4jcheck
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to check for vulnerable Log4j (CVE-2021-44228) systems";
    homepage = "https://github.com/NorthwaveSecurity/log4jcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "log4jcheck";
  };
}
