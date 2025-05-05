{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vegur";
  version = "${finalAttrs.majorVersion}.${finalAttrs.minorVersion}";
  majorVersion = "0";
  minorVersion = "701";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/vegur_${finalAttrs.majorVersion}${finalAttrs.minorVersion}.zip";
    hash = "sha256-sGb3mEb3g15ZiVCxEfAanly8zMUopLOOjw8W4qbXLPA=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/fonts/vegur/";
    description = "Humanist sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      djacu
      minijackson
    ];
    license = licenses.cc0;
  };
})
