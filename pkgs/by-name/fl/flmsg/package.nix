{
  lib,
  stdenv,
  fetchurl,
  fltk_1_3,
  libjpeg,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.0.24";
  pname = "flmsg";
  src = fetchurl {
    url = "mirror://sourceforge/fldigi/flmsg-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-kzQHmND5zK/Hy40Z0RRstnJ5x5cjxDax0l2idjmeBpQ=";
  };

  #This has been reported to upstream via email : w1hkj@w1hkj.com
  patches = [
    ./add-missing-pthread-include.patch
  ];

  buildInputs = [
    fltk_1_3
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "flmsg";
  };
})
