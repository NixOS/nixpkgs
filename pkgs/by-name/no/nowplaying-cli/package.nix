{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nowplaying-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "kirtan-shah";
    repo = "nowplaying-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FkyrtgsGzpK2rLNr+oxfPUbX43TVXYeiBg7CN1JUg8Y=";
  };

  installPhase = ''
    runHook preInstall

    install -D nowplaying-cli $out/bin/nowplaying-cli

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS command-line utility for retrieving currently playing media";
    homepage = "https://github.com/kirtan-shah/nowplaying-cli";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
    mainProgram = "nowplaying-cli";
  };
})
