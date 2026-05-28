{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lklug-sinhala";
  version = "0.6";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-lklug-sinhala/fonts-lklug-sinhala_${finalAttrs.version}.orig.tar.xz";
    hash = "sha256-oPCCa01PMQcCK5fEILgXjrGzoDg+UvxkqK6AgeQaKio=";
  };

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    description = "Unicode Sinhala font by Lanka Linux User Group";
    homepage = "http://www.lug.lk/fonts/lklug";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
})
