{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hauk";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "bilde2910";
    repo = "Hauk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5OXAFkaQ1nmeF6AjFQ81JCD8mZCIZAPz0JEK9cwghI=";
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
