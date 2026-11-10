{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cldr-annotations";
  version = "49";

  src = fetchzip {
    url = "https://unicode.org/Public/cldr/${version}/cldr-common-${version}.zip";
    stripRoot = false;
    hash = "sha256-s0nDPUMwP/DgeL7PdeKyFASAU8hTHw644qPWrl+F6zw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode/cldr/common
    mv common/annotations{,Derived} -t $out/share/unicode/cldr/common

    runHook postInstall
  '';

  meta = {
    description = "Names and keywords for Unicode characters from the Common Locale Data & Rules";
    homepage = "https://cldr.unicode.org";
    license = lib.licenses.unicode-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
  };
}
