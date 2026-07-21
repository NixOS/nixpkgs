{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plus-jakarta-sans";
  version = "2.7.1";

  src = fetchzip {
    url = "https://github.com/tokotype/PlusJakartaSans/releases/download/${finalAttrs.version}/PlusJakartaSans-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-+ghkQ4/wxou3FB68ceCwBeGrSCaHJhb16MybvN6mCSc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp PlusJakartaSans-$version/*/PlusJakartaSans*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.tokotype.com/custom-fonts/plusjakarta";
    description = "Typeface designed for Jakarta 'City of collaboration' program in 2020";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
})
