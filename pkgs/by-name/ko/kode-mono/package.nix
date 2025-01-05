{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kode-mono";
  version = "1.206";

  src = fetchzip {
    url = "https://github.com/isaozler/kode-mono/releases/download/${finalAttrs.version}/kode-mono-fonts.zip";
    hash = "sha256-0EZTlSqGCavSwjpKcEFv2L/bkKLE2jLyBWPSnmxQ3ww=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 kode-mono-fonts/fonts/ttf/*.ttf      -t $out/share/fonts/truetype/
    install -Dm644 kode-mono-fonts/fonts/variable/*.ttf -t $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Custom-designed typeface explicitly created for the developer community";
    homepage = "https://kodemono.com/";
    changelog = "https://github.com/isaozler/kode-mono/blob/main/CHANGELOG.md";
    license = licenses.ofl;
    maintainers = [ maintainers.isaozler ];
    platforms = platforms.all;
  };
})
