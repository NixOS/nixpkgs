{
  lib,
  stdenv,
  fetchurl,
  unzip,
  perl,
  libX11,
  libXpm,
  gpm,
  ncurses,
  slang,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fte";
  version = "0.50.02";

  ftesrc = fetchurl {
    url = "mirror://sourceforge/fte/fte-20110708-src.zip";
    hash = "sha256-1jEcVC0/DyiQpUpmHDtnIo4nuJS0Fk6frynwFPJUSZ4=";
  };

  ftecommon = fetchurl {
    url = "mirror://sourceforge/fte/fte-20110708-common.zip";
    hash = "sha256-WEEVeLMZWHZfQtK/Kbeu3Z+RaVXCwZyWkJocA+Akavc=";
  };

  src = [
    finalAttrs.ftesrc
    finalAttrs.ftecommon
  ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    perl
    libX11
    libXpm
    gpm
    ncurses
    slang
  ];

  hardeningDisable = [ "all" ];
  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-DHAVE_STRLCAT -DHAVE_STRLCPY";
  installFlags = [ "INSTALL_NONROOT=1" ];

  # not setting it cause fte to not find xfte
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Free text editor for developers";
    homepage = "https://fte.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
