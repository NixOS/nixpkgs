{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mo";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "tests-always-included";
    repo = pname;
    rev = version;
    hash = "sha256-CFAvTpziKzSkdomvCf8PPXYbYcJxjB4EValz2RdD2b0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp mo $out/bin/.

    runHook postInstall
  '';

  meta = with lib; {
    description = "Moustache templates for Bash";
    homepage = "https://github.com/tests-always-included/mo";
    license = licenses.mit;
    maintainers = with maintainers; [ sheepforce ];
  };
}
