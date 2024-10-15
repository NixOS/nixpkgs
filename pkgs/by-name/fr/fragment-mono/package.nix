{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fragment-mono";
  version = "1.21";

  src = fetchzip {
    url = "https://github.com/weiweihuanghuang/fragment-mono/releases/download/${finalAttrs.version}/fragment-mono-${finalAttrs.version}.zip";
    hash = "sha256-H5s4rYDN2d0J+zVRgBzg8vfZXCA/jjHrGBV8o8Dxutc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/weiweihuanghuang/fragment-mono";
    description = "Helvetica Monospace Coding Font";
    changelog = "https://github.com/weiweihuanghuang/fragment-mono/releases/tag/${finalAttrs.version}";
    longDescription = ''
      Fragment Mono is a monospaced coding version of Helvetica created
      by modifying and extending Nimbus Sans by URW Design Studio.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.noahgitsham ];
  };
})
