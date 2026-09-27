{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fantasque-sans-mono";
  version = "1.8.0";

  outputs = [
    "out"
    "webfont"
    "doc"
  ];

  src = fetchzip {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${finalAttrs.version}/FantasqueSansMono-Normal.zip";
    stripRoot = false;
    hash = "sha256-MNXZoDPi24xXHXGVADH16a3vZmFhwX0Htz02+46hWFc=";
  };

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall

    install -m644 -Dt $doc/share/doc/${finalAttrs.pname}-${finalAttrs.version} {*.md,*.txt}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "Font family with a great monospaced variant for programmers";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
