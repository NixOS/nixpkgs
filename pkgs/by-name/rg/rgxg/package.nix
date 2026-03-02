{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rgxg";
  version = "0.1.2";

  src = fetchzip {
    url = "https://github.com/rgxg/rgxg/releases/download/v${finalAttrs.version}/rgxg-${finalAttrs.version}.tar.gz";
    sha256 = "050jxc3qhfrm9fdbzd67hlsqlp4qk1fa20q1g2v919sh7s6v77si";
  };

  meta = {
    description = "C library and a command-line tool to generate (extended) regular expressions";
    mainProgram = "rgxg";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ hloeffler ];
    homepage = "https://rgxg.github.io/";
  };
})
