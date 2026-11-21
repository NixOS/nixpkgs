{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hauk";
  version = "1.6.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bilde2910";
    repo = "Hauk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MfAmSY9bkvX4Dq+DZ3MkqPL20q5c4fThW9mrO+X0D+8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R ./backend-php/* $out/
    cp -R ./frontend/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Fully open source, self-hosted location sharing service";
    homepage = "https://github.com/bilde2910/Hauk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hlad ];
    platforms = lib.platforms.unix;
  };
})
