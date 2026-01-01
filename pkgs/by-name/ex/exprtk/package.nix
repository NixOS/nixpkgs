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

<<<<<<< HEAD
  meta = {
    description = "C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
