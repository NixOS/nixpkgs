{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "cardo";
  version = "1.04";

  src = fetchzip {
    url = "https://scholarsfonts.net/cardo104.zip";
    stripRoot = false;
    hash = "sha256-NU6/H5f0JBlVo3L3uUcl7IvNxPMXD8UQY9k5o2YA5Vo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Large Unicode font specifically designed for the needs of classicists, Biblical scholars, medievalists, and linguists";
    longDescription = ''
      Cardo is a large Unicode font specifically designed for the needs of
      classicists, Biblical scholars, medievalists, and linguists. It also
      works well for general typesetting in situations where a high-quality Old
      Style font is appropriate. Its large character set supports many modern
      languages as well as those needed by scholars. Cardo also contains
      features that are required for high-quality typography such as ligatures,
      text figures (also known as old style numerals), true small capitals and
      a variety of punctuation and space characters.
    '';
    homepage = "http://scholarsfonts.net/cardofnt.html";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ kmein ];
    platforms = platforms.all;
  };
}
