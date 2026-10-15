{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "breathe-cli";
  version = "1.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marekkowalczyk";
    repo = "breathe-cli";
    rev = "v${version}";
    hash = "sha256-kxbR5FLB7zdHm7TzYt9NEP0aZxcAVPH2JOKfYEAQtZs=";
  };

  format = "other";

  installPhase = ''
    runHook preInstall
    install -Dm755 breathe.py $out/bin/breathe
    runHook postInstall
  '';

  meta = {
    description = "Paced resonance breathing for vagal tone training";
    homepage = "https://github.com/marekkowalczyk/breathe-cli";
    license = lib.licenses.mit;
    mainProgram = "breathe";
    maintainers = with lib.maintainers; [ mio ];
  };
}
