{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  allegro,
  perl,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgui";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/cgui/${finalAttrs.version}/cgui-${finalAttrs.version}.tar.gz";
    sha256 = "1pp1hvidpilq37skkmbgba4lvzi01rasy04y0cnas9ck0canv00s";
  };

  buildInputs = [
    texinfo
    allegro
    perl
    libx11
  ];

  configurePhase = ''
    runHook preConfigure

    sh fix.sh unix

    runHook postConfigure
  '';

  hardeningDisable = [ "format" ];

  makeFlags = [ "SYSTEM_DIR=$(out)" ];

  meta = {
    description = "Multiplatform basic GUI library";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
  };
})
