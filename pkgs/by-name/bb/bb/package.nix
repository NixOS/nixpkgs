{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  aalib,
  ncurses,
  libxdmcp,
  libxau,
  libx11,
  libmikmod,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bb";
  version = "1.3rc1";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/bb/${finalAttrs.version}/bb-${finalAttrs.version}.tar.gz";
    sha256 = "1i411glxh7g4pfg4gw826lpwngi89yrbmxac8jmnsfvrfb48hgbr";
  };

  patches = [
    # add / update include files to get function prototypes
    ./included-files-updates.diff
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    aalib
    ncurses
    libmikmod
    libxau
    libxdmcp
    libx11
  ];

  # regparm attribute is not supported by clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace config.h \
      --replace-fail "__attribute__ ((regparm(n)))" ""
  '';

  meta = {
    homepage = "http://aa-project.sourceforge.net/bb";
    description = "AA-lib demo";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.rnhmjoj ];
    platforms = lib.platforms.unix;
    mainProgram = "bb";
  };
})
