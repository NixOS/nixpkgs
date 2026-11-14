{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "latexrun";
  version = "0-unstable-2015-11-18";
  src = fetchFromGitHub {
    owner = "aclements";
    repo = "latexrun";
    rev = "38ff6ec2815654513c91f64bdf2a5760c85da26e";
    hash = "sha256-HBEVQo84N7Vrl1hmjsvlqdK3fOdMoClPNnc1YCdJtHU=";
  };

  buildInputs = [ python3 ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp latexrun $out/bin/latexrun
    chmod +x $out/bin/latexrun
  '';

  meta = {
    description = "21st century LaTeX wrapper";
    mainProgram = "latexrun";
    homepage = "https://github.com/aclements/latexrun";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lucus16 ];
    platforms = lib.platforms.all;
  };
}
