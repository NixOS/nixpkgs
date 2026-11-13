{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  version = "1.4.0";
  releaseDate = "20261003";
in
stdenvNoCC.mkDerivation {
  pname = "d2codingfont";
  inherit version;

  src = fetchzip {
    url = "https://github.com/naver/d2-coding-font/releases/download/VER${version}/D2Coding-Ver${version}-${releaseDate}.zip";
    stripRoot = false;
    hash = "sha256-+kzLE7laRUheaEN+54DoAvkX4YC8Wv7NZva4T7kf2mo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*-all.ttc -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    description = "Monospace font with support for Korean and latin characters";
    longDescription = ''
      D2Coding is a monospace font developed by a Korean IT Company called Naver.
      Font is good for displaying both Korean characters and latin characters,
      as sometimes these two languages could share some similar strokes.
      Since version 1.3, D2Coding font is officially supported by the font
      creator, with symbols for Powerline.
    '';
    homepage = "https://github.com/naver/d2-coding-font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      constkarma
    ];
  };
}
