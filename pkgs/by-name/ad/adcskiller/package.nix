{
  lib,
  fetchFromGitHub,
  python3,
  coercer,
}:

python3.pkgs.buildPythonApplication {
  pname = "adcskiller";
  version = "0-unstable-2024-05-19";
  format = "other";

  src = fetchFromGitHub {
    owner = "grimlockx";
    repo = "ADCSKiller";
    rev = "d74bfea91f24a09df74262998d60f213609b45c6";
    hash = "sha256-ekyGDM9up3h6h21uLEstgn33x+KngX4tOLMhL4B6BA8=";
  };

  buildInputs = [
    coercer
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ldap3
    certipy
  ];

  installPhase = ''
    runHook preInstall

    install -vD $pname.py $out/bin/$pname

    substituteInPlace $out/bin/$pname --replace '"Coercer"' '"coercer"'

    runHook postInstall
  '';

  meta = {
    description = "Python-based tool designed to automate the process of discovering and exploiting Active Directory Certificate Services (ADCS) vulnerabilities";
    homepage = "https://github.com/grimlockx/ADCSKiller";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ exploitoverload ];
    mainProgram = "ADCSKiller";
  };
}
