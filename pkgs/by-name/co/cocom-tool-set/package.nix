{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cocom";
  version = "0.996";

  src = fetchurl {
    url = "mirror://sourceforge/cocom/cocom-${finalAttrs.version}.tar.gz";
    hash = "sha256-4UOrVW15o17zHsHiQIl8m4qNC2aT5QorbkfX/UsgBRk=";
  };

  patches = lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) ./fix-cross-build.patch;

  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace DINO/Makefile.in
      --replace-fail ../SPRUT/sprut "${buildPackages.cocom-tool-set}"/bin/sprut
  '';

  env = {
    RANLIB = "${stdenv.cc.targetPrefix}gcc-ranlib";
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
      "-std=gnu17"
    ];
  };

  # cocom does $(DESTDIR)/$(libdir) which results in //nix/store/...
  # on cygwin this is interpreted as a network path.
  ${if stdenv.buildPlatform.isCygwin then "installFlags" else null} =
    lib.optionalString stdenv.buildPlatform.isCygwin "DESTDIR=/.";

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
