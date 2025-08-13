{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  bison,
  file,
  perl,
  pkg-config,
  boehmgc,
  gperf,
  libpaper,
}:

stdenv.mkDerivation rec {
  pname = "a2ps";
  version = "4.15.7";

  src = fetchurl {
    url = "mirror://gnu/a2ps/a2ps-${version}.tar.gz";
    hash = "sha256-cV84Zwr9lQtMpxwB9Gj+760mXKUtPxEpNMY8Cov7uK8=";
  };

  postPatch = ''
    substituteInPlace afm/make_fonts_map.sh --replace "/bin/rm" "rm"
    substituteInPlace tests/defs.in --replace "/bin/rm" "rm"
  '';

  nativeBuildInputs = [
    autoconf
    bison
    file
    perl
    pkg-config
  ];
  buildInputs = [
    boehmgc
    gperf
    libpaper
  ];

  strictDeps = true;

  meta = {
    description = "Anything to PostScript converter and pretty-printer";
    longDescription = ''
      GNU a2ps converts files into PostScript for printing or viewing. It uses a nice default format,
      usually two pages on each physical page, borders surrounding pages, headers with useful information
      (page number, printing date, file name or supplied header), line numbering, symbol substitution as
      well as pretty printing for a wide range of programming languages.
    '';
    homepage = "https://www.gnu.org/software/a2ps/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
  };
}
