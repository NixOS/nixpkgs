{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fira-go";
  version = "1.001";

  src = fetchzip {
    url = "https://carrois.com/downloads/FiraGO/Download_Folder_FiraGO_${
      lib.replaceStrings [ "." ] [ "" ] version
    }.zip";
    hash = "sha256-+lw4dh7G/Xv3pzGXdMUl9xNc2Nk7wUOAh+lq3K1LrXs=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install --mode=644 -Dt $out/share/fonts/opentype Download_Folder_FiraGO*/Fonts/FiraGO_OTF*/*/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://carrois.com/fira/";
    description = ''
      Font with the same glyph set as Fira Sans 4.3 and additionally
      supports Arabic, Devenagari, Georgian, Hebrew and Thai
    '';
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.loicreynier ];
    platforms = lib.platforms.all;
  };
}
