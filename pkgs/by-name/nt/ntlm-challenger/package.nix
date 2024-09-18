{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication {
  pname = "ntlm-challenger";
  version = "0-unstable-2022-11-10";
  format = "other";

  src = fetchFromGitHub {
    owner = "nopfor";
    repo = "ntlm_challenger";
    rev = "bd61ef65c7692fb1968383894da662bf99026aec";
    hash = "sha256-F9aZB8M25gPDY7J7cXkAH30m7zmk4NHczUHyBDBZInA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
    impacket
  ];

  installPhase = ''
    runHook preInstall

    install -D ntlm_challenger.py $out/bin/ntlm_challenger

    runHook postInstall
  '';

  meta = with lib; {
    description = "Parse NTLM challenge messages over HTTP and SMB";
    mainProgram = "ntlm_challenger";
    homepage = "https://github.com/nopfor/ntlm_challenger";
    license = licenses.mit;
    maintainers = [ maintainers.crem ];
  };
}
