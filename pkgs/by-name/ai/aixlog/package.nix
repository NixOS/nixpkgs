{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "aixlog";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "aixlog";
    tag = "v${version}";
    hash = "sha256-Xhle7SODRZlHT3798mYIzBi1Mqjz8ai74/UnbVWetiY=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/include/aixlog.hpp $out/include/aixlog.hpp

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Header-only C++ logging library";
    homepage = "https://github.com/badaix/aixlog";
    changelog = "https://github.com/badaix/aixlog/releases/tag/${src.rev}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Header-only C++ logging library";
    homepage = "https://github.com/badaix/aixlog";
    changelog = "https://github.com/badaix/aixlog/releases/tag/${src.rev}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
