{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  version = "0.46";
  assetVersion = lib.replaceStrings [ "." ] [ "" ] version;
in
stdenvNoCC.mkDerivation {
  pname = "dseg";
  inherit version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/keshikan/DSEG/releases/download/v${version}/fonts-DSEG_v${assetVersion}.zip";
    hash = "sha256-subUn6ZCtzXQZXvmwVBUkOvD47m3zgZ9EFOTC1Vyc0k=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype */*.ttf
    install -D -m444 -t $out/share/doc/dseg DSEG-LICENSE.txt README.md

    runHook postInstall
  '';

  meta = {
    description = "Font family that imitates seven- and fourteen-segment LCD displays";
    homepage = "https://www.keshikan.net/fonts-e.html";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ thalbedl ];
    platforms = lib.platforms.all;
  };
}
