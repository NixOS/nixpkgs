{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enscript";
  version = "1.6.6";

  src = fetchurl {
    url = "mirror://gnu/enscript/enscript-${finalAttrs.version}.tar.gz";
    sha256 = "1fy0ymvzrrvs889zanxcaxjfcxarm2d3k43c9frmbl1ld7dblmkd";
  };

  patches = [
    # fix compile failure on macos. use system getopt like linux
    # requires that compat/getopt.h is also removed
    # https://savannah.gnu.org/bugs/?64307
    ./0001-use-system-getopt.patch
    # Fix build with gcc15
    #   regex.c:3565:13: error: too many arguments to function 're_match_2_internal'; expected 0, have 8
    (fetchpatch2 {
      url = "https://salsa.debian.org/debian/enscript/-/raw/7a51479540a210dee5eee4ece5b54e3ce15dec52/debian/patches/1096582-gcc-15";
      hash = "sha256-0H8FNCKgQ1YCwcBaMChQSuFaYlmzSsoqtfsNSr567+Y=";
    })
  ];

  postPatch = ''
    # the delete component of 0001-use-system-getopt.patch
    rm compat/getopt.h
    # Fix building on Darwin with GCC.
    substituteInPlace compat/regex.c --replace \
       __private_extern__  '__attribute__ ((visibility ("hidden")))'
  '';

  buildInputs = [ gettext ];

  doCheck = true;

  meta = {
    description = "Converter from ASCII to PostScript, HTML, or RTF";

    longDescription = ''
      GNU Enscript converts ASCII files to PostScript, HTML, or RTF and
      stores generated output to a file or sends it directly to the
      printer.  It includes features for `pretty-printing'
      (language-sensitive code highlighting) in several programming
      languages.

      Enscript can be easily extended to handle different output media and
      it has many options that can be used to customize printouts.
    '';

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/enscript/";

    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "enscript";
  };
})
