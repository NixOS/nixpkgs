{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "mitimasu";
  version = "0-unstable-2023-10-24";

  src = fetchFromGitHub {
    owner = "kemomimi-no-sato";
    repo = "mitimasu-webfont";
    rev = "6798f7a192d5c60adf75a3d32184057b8579e3c5";
    hash = "sha256-yiAnIVZY9DoIborO/s2KSlt6Zq1kAjKewLd30qBQqio=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/mitimasu.ttf
    install -m444 -Dt $out/share/fonts/eot fonts/mitimasu.eot
    install -m444 -Dt $out/share/fonts/woff fonts/mitimasu.woff
    install -m444 -Dt $out/share/fonts/woff2 fonts/mitimasu.woff2

    runHook postInstall
  '';

  meta = {
    description = "Mitimasu webfont";
    homepage = "https://github.com/kemomimi-no-sato/mitimasu-webfont";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ istudyatuni ];
  };
}
