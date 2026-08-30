{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cksfv";
  version = "1.3.15";

  src = fetchurl {
    url = "https://zakalwe.fi/~shd/foss/cksfv/files/cksfv-${finalAttrs.version}.tar.bz2";
    sha256 = "0k06aq94cn5xp4knjw0p7gz06hzh622ql2xvnrlr3q8rcmdvwwx1";
  };

  meta = {
    homepage = "https://zakalwe.fi/~shd/foss/cksfv/";
    description = "Tool for verifying files against a SFV checksum file";
    maintainers = [ ];
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
    mainProgram = "cksfv";
  };
})
