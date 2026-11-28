{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hauk";
  version = "1.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bilde2910";
    repo = "Hauk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aV8a0aOFUMvdTLCJNQGtFv1ToszreDoPSh1mVa1FE5c=";
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
