{ lib, gccStdenv, fetchFromGitHub }:

gccStdenv.mkDerivation rec {
  pname = "cc65";
  version = "2.19";

  src = fetchFromGitHub {
    owner = "cc65";
    repo = pname;
    rev = "V${version}";
    sha256 = "01a15yvs455qp20hri2pbg2wqvcip0d50kb7dibi9427hqk9cnj4";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://cc65.github.io/";
    description = "C compiler for processors of 6502 family";
    longDescription = ''
      cc65 is a complete cross development package for 65(C)02 systems,
      including a powerful macro assembler, a C compiler, linker, librarian and
      several other tools.

      cc65 has C and runtime library support for many of the old 6502 machines,
      including the following Commodore machines:

      - VIC20
      - C16/C116 and Plus/4
      - C64
      - C128
      - CBM 510 (aka P500)
      - the 600/700 family
      - newer PET machines (not 2001).
      - the Apple ][+ and successors.
      - the Atari 8-bit machines.
      - the Atari 2600 console.
      - the Atari 5200 console.
      - GEOS for the C64, C128 and Apple //e.
      - the Bit Corporation Gamate console.
      - the NEC PC-Engine (aka TurboGrafx-16) console.
      - the Nintendo Entertainment System (NES) console.
      - the Watara Supervision console.
      - the VTech Creativision console.
      - the Oric Atmos.
      - the Oric Telestrat.
      - the Lynx console.
      - the Ohio Scientific Challenger 1P.

      The libraries are fairly portable, so creating a version for other 6502s
      shouldn't be too much work.
    '';
    license = licenses.zlib;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
