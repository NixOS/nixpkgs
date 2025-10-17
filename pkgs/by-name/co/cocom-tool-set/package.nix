{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cocom";
  version = "0.996";

  src = fetchurl {
    url = "mirror://sourceforge/cocom/cocom-${finalAttrs.version}.tar.gz";
    hash = "sha256-4UOrVW15o17zHsHiQIl8m4qNC2aT5QorbkfX/UsgBRk=";
  };

  env = {
    RANLIB = "${stdenv.cc.targetPrefix}gcc-ranlib";
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
    ];
  };

  autoreconfFlags = "REGEX";

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Tool set oriented towards the creation of compilers";
    homepage = "https://cocom.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.unix;
  };
})
