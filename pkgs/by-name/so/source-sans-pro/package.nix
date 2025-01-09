{
  lib,
  stdenvNoCC,
  fetchzip,
}:

# Source Sans Pro got renamed to Source Sans 3 (see
# https://github.com/adobe-fonts/source-sans/issues/192). This is the
# last version named "Pro". It is useful for backward compatibility
# with older documents/templates/etc.

stdenvNoCC.mkDerivation rec {
  name = "source-sans-pro-${version}";
  version = "3.006";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";
    hash = "sha256-1Savijgq3INuUN89MR0t748HOuGseXVw5Kd4hYwuVas=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm444 TTF/*.ttf -t $out/share/fonts/truetype
    install -Dm444 VAR/*.otf -t $out/share/fonts/variable

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
