{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arphic-ukai";
  version = "0.2.20080216.2";

  src = fetchzip {
    url = "mirror://ubuntu/pool/main/f/fonts-arphic-ukai/fonts-arphic-ukai_${finalAttrs.version}.orig.tar.bz2";
    hash = "sha256-GS1ek0rmxykTfNZR3muieS5e4O7nWnwnhb7KJZ/8YT8=";
  };

  nativeBuildInputs = [
    installFonts
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "CJK Unicode font Kai style";
    homepage = "https://www.freedesktop.org/wiki/Software/CJKUnifonts/";
    license = lib.licenses.arphicpl;
    maintainers = with lib.maintainers; [
      changlinli
      ccicnce113424
    ];
    platforms = lib.platforms.all;
  };
})
