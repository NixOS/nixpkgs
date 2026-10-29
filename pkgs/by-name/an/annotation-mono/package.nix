{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "annotation-mono";
  version = "0.4";

  src = fetchzip {
    url = "https://github.com/qwerasd205/AnnotationMono/releases/download/v${finalAttrs.version}/AnnotationMono_v${finalAttrs.version}.zip";
    hash = "sha256-6DEYTYAENNY/5oD9us9f7VtPae/it7qrFC3/UT1J+Qg=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/dist/ttf/*.ttf
    install -D -m444 -t $out/share/fonts/truetype $src/dist/variable/AnnotationMono-VF.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/dist/otf/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/qwerasd205/AnnotationMono";
    description = "Lovingly crafted handwriting-style monospace font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.theonlymrcat ];
  };
})
