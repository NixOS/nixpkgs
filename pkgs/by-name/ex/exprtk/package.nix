{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "exprtk";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ArashPartow";
    repo = "exprtk";
    rev = version;
    hash = "sha256-A4UzNYZZGgTJOw9G4Jg1wJZhxguFRohNEcwmwUOAX18=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 exprtk.hpp "$out/include/exprtk.hpp"
    runHook postInstall
  '';

  meta = with lib; {
    description = "C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = licenses.mit;
    maintainers = [ ];
  };
}
