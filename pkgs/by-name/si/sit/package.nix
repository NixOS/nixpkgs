{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "sit";
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "thecloudexpanse";
    repo = "sit";
    rev = "8e3d6416c2b61db99c74e8f1224431dc33a50a34";
    hash = "sha256-uaeHntgvuyeRKJR7BmHtXdM+70xfdrd4WPQagXkWV/Q=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 sit $out/bin/sit
    install -Dm755 macbinfilt $out/bin/macbinfilt
    runHook postInstall
  '';

  meta = {
    description = "Create StuffIt archives on Unix systems";
    homepage = "https://github.com/thecloudexpanse/sit";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "sit";
    platforms = lib.platforms.unix;
  };
}
