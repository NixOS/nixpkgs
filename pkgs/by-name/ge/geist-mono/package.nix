{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "geist-mono";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/vercel/geist-font/releases/download/${finalAttrs.version}/Geist.Mono.zip";
    stripRoot = false;
    hash = "sha256-8I4O2+bJAlUiDIhbyXzAcwXP5qpmHoh4IfrFio7IZN8=";
  };

  outputs = [ "out" ];

  installPhase = ''
    runHook preInstall

    pushd Geist.Mono
    install -Dm644 *.otf -t $out/share/fonts/opentype
    popd

    runHook postInstall
  '';

  meta = {
    description = "A monospaced font by Vercel's creative community";
    homepage = "https://vercel.com/font/mono";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ x0ba ];
    platforms = lib.platforms.all;
  };
})
