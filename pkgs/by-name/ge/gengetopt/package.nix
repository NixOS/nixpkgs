{
  fetchurl,
  lib,
  stdenv,
  texinfo,
  help2man,
}:

stdenv.mkDerivation rec {
  pname = "gengetopt";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1b44fn0apsgawyqa4alx2qj5hls334mhbszxsy6rfr0q074swhdr";
  };

  doCheck = true;
  # attempts to open non-existent file
  preCheck = ''
    rm tests/test_conf_parser_save.sh
  '';

  # test suite is not thread safe
  enableParallelBuilding = false;

  nativeBuildInputs = [
    texinfo
    help2man
  ];

  #Fix, see #28255
  postPatch = ''
    substituteInPlace configure --replace \
      'set -o posix' \
      'set +o posix'
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = "-std=c++14";
  };

  meta = {
    description = "Command-line option parser generator";
    mainProgram = "gengetopt";

    longDescription = ''
      GNU Gengetopt program generates a C function that uses getopt_long
      function to parse the command line options, to validate them and
      fills a struct
    '';

    homepage = "https://www.gnu.org/software/gengetopt/";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
