{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "source-han-code-jp";
  version = "2.012";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/${pname}/archive/${version}R.zip";
    hash = "sha256-ljO/1/CaE9Yj+AN5xxlIr30/nV/axGQPO0fGACAZGCQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 OTF/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Monospaced Latin font suitable for coding";
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = with lib.platforms; all;
    homepage = "https://blogs.adobe.com/CCJKType/2015/06/source-han-code-jp.html";
    license = lib.licenses.ofl;
  };
}
