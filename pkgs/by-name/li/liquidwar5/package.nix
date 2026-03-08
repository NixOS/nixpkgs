{
  lib,
  stdenv,
  fetchurl,
  allegro,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "5.6.6";
  pname = "liquidwar5";
  src = fetchurl {
    url = "http://www.ufoot.org/download/liquidwar/v5/${finalAttrs.version}/liquidwar-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-JF2AZuzDiCm9EQ8AiQ6230TgmMgML7yJpG80BFqsQ/c=";
  };

  buildInputs = [ allegro ];

  configureFlags = lib.optional stdenv.hostPlatform.isx86_64 "--disable-asm";

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: random.o:(.bss+0x0): multiple definition of `LW_RANDOM_ON'; game.o:(.bss+0x4): first defined here
    "-fcommon"

    "-lm"
  ];

  meta = {
    description = "Classic version of a quick tactics game LiquidWar";
    maintainers = [ lib.maintainers.raskin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
