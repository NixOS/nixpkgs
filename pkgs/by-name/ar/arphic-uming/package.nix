{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arphic-uming";
  version = "0.2.20080216.2";

  src = fetchzip {
    url = "mirror://ubuntu/pool/main/f/fonts-arphic-uming/fonts-arphic-uming_${finalAttrs.version}.orig.tar.bz2";
    hash = "sha256-icAofajFV1WcgxG+cHu5y8IF5vTtJ8ryx74SYsIVw4I=";
  };

  nativeBuildInputs = [
    installFonts
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "CJK Unicode font Ming style";
    homepage = "https://www.freedesktop.org/wiki/Software/CJKUnifonts/";
    license = lib.licenses.arphicpl;
    maintainers = with lib.maintainers; [
      changlinli
      ccicnce113424
    ];
    platforms = lib.platforms.all;
  };
})
