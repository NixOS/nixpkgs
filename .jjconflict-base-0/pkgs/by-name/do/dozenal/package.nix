{ lib, stdenv, fetchFromGitHub, ncurses, hdate, lua5_2 }:

stdenv.mkDerivation rec {
  version = "12010904";
  pname = "dozenal";
  src = fetchFromGitHub {
    owner = "dgoodmaniii";
    repo = "dozenal";
    rev = "v${version}";
    sha256 = "1ic63gpdda762x6ks3al71dwgmsy2isicqyr2935bd245jx8s209";
  };
  makeFlags = [
              # author do not use configure and prefix directly using $prefix
              "prefix=$(out)"
              # graphical version of dozdc requires xforms, which is not i nixpkgs so I turned it down
              "XFORMS_FLAGS=-UXFORMS"
              "LUALIB=-llua"
              "bindir=$(prefix)/bin/"
            ];
  # some include hardcodes the lua libraries path. This is a patch for that
  patches = [ ./lua-header.patch ];
  preBuild = "cd dozenal";
  buildInputs = [ ncurses hdate lua5_2 ];

  # Parallel builds fail due to no dependencies between subdirs.
  # As a result some subdirs are atempted to build twice:
  #   ../dec/dec.c:39:10: fatal error: conv.h: No such file or directory
  # Let's disable parallelism until it's fixed upstream:
  #  https://gitlab.com/dgoodmaniii/dozenal/-/issues/8
  enableParallelBuilding = false;

  # I remove gdozdc, as I didn't figure all it's dependency yet.
  postInstall = "rm $out/bin/gdozdc";

  meta = {
    description = "Complete suite of dozenal (base twelve) programs";
    longDescription = ''
      Programs

      doz --- a converter; converts decimal numbers into dozenal. Accepts
         input in standard or exponential notation (i.e., "1492.2" or "1.4922e3").
      dec --- a converter; converts dozenal numbers into decimal. Accepts input
         in standard or exponential notation (i.e., "X44;4" or "X;444e2").
      dozword --- converts a dozenal number (integers only) into words,
         according to the Pendlebury system.
      dozdc --- a full-featured scientific calculator which works in the
         dozenal base. RPN command line.
      tgmconv --- a converter for all standard measurements; converts to and
         from TGM, Imperial, customary, and SI metric.
      dozpret --- a pretty-printer for dozenal numbers; inserts spacing (or
         other characters) as desired, and can also transform transdecimal digits
         from 'X' to 'E' into any character or sequence of characters desired.
      dozdate --- a more-or-less drop-in replacement for GNU and BSD date, it
         outputs the date and time in dozenal, as well as containing some TGM
         extensions.
      dozstring --- a simple byte converter; absorbs a string either from
         standard input or a command line argument, leaving it identical but
         for the numbers, which it converts into dozenal. Options for padding
         and for not converting specific numbers.
      doman --- a converter which takes a dozenal integer and
         emits its equivalent in a non-place-value system, such as
         Roman numerals.  Arbitrary ranks and symbols may be used.
         Defaults to dozenal Roman numerals.
    '';
    homepage = "https://github.com/dgoodmaniii/dozenal/";
    maintainers = with lib.maintainers; [ CharlesHD ];
    license = lib.licenses.gpl3;
  };
}
