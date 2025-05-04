{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "abnes-font";
  version = "1.0.0";

  src = fetchzip {
    url = "https://befonts.com/wp-content/uploads/2020/10/abnes.zip";
    hash = "sha256-x/AhooCW0+JF66kNaY96iB3+HpAd+l6QJ3bDZxf1xXk=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src/*.ttf -t $out/share/fonts/truetype
    install -Dm644 $src/*.otf -t $out/share/fonts/opentype

    cp -p $src/Misc/License.txt $out/

    runHook postInstall
  '';

  meta = {
    description = "Font made by 177 Studio free for personal use.";
    homepage = "https://177studio.com/product/abnes-elegant-sans-serif-font/";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      DrVoidest
    ];
  };
}
