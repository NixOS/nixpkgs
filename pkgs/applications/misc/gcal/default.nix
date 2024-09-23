{ lib, stdenv, fetchurl, ncurses, gettext, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gcal";
  version = "4.1";

  src = fetchurl {
    url = "mirror://gnu/gcal/${pname}-${version}.tar.xz";
    sha256 = "1av11zkfirbixn05hyq4xvilin0ncddfjqzc4zd9pviyp506rdci";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gcal/raw/master/f/gcal-glibc-no-libio.patch";
      sha256 = "0l4nw9kgzsay32rsdwvs75pbp4fhx6pfm85paynfbd20cdm2n2kv";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-implicit-function-declaration";

  enableParallelBuilding = true;

  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin gettext;

  meta = {
    description = "Program for calculating and printing calendars";
    longDescription = ''
      Gcal is the GNU version of the trusty old cal(1). Gcal is a
      program for calculating and printing calendars. Gcal displays
      hybrid and proleptic Julian and Gregorian calendar sheets.  It
      also displays holiday lists for many countries around the globe.
    '';
    homepage = "https://www.gnu.org/software/gcal/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "gcal";
  };
}
