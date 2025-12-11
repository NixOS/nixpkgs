{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "geist-font";
  version = "1.5.0";

  srcs = [
    (fetchzip {
      url = "https://github.com/vercel/geist-font/releases/download/${finalAttrs.version}/geist-font-${finalAttrs.version}.zip";
      hash = "sha256-p3nFuaQPvw4PLcb5AOhu9jiNCTzZD7st1MuJKTAzwKE=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D source/fonts/{Geist,GeistMono}/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ x0ba ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
