{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exprtk";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ArashPartow";
    repo = "exprtk";
    rev = finalAttrs.version;
    hash = "sha256-A4UzNYZZGgTJOw9G4Jg1wJZhxguFRohNEcwmwUOAX18=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 exprtk.hpp "$out/include/exprtk.hpp"
    runHook postInstall
  '';

  meta = {
    description = "C++ Mathematical Expression Toolkit Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
