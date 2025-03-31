{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  aalib,
  ncurses,
  xorg,
  libmikmod,
}:

stdenv.mkDerivation rec {
  pname = "bb";
  version = "1.3rc1";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/bb/${version}/${pname}-${version}.tar.gz";
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
    xorg.libXau
    xorg.libXdmcp
    xorg.libX11
  ];

  # regparm attribute is not supported by clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace config.h \
      --replace-fail "__attribute__ ((regparm(n)))" ""
  '';

  meta = with lib; {
    homepage = "http://aa-project.sourceforge.net/bb";
    description = "AA-lib demo";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rnhmjoj ];
    platforms = platforms.unix;
    mainProgram = "bb";
  };
}
