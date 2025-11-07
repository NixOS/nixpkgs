{
  lib,
  stdenv,
  fetchurl,
  gettext,
  emacs,
}:

stdenv.mkDerivation rec {
  pname = "cflow";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/cflow/cflow-${version}.tar.bz2";
    hash = "sha256-gyFie1W2x4d/akP8xvn4RqlLFHaggaA1Rl96eNNJmrg=";
  };

  postPatch = ''
    substituteInPlace "config.h.in" \
      --replace-fail "[[__maybe_unused__]]" "__attribute__((__unused__))"
    substituteInPlace "src/cflow.h" \
      --replace-fail "/usr/bin/cpp" "${stdenv.cc.cc}/bin/cpp"
  '';

  buildInputs = [
    gettext
  ]
  ++
    # We don't have Emacs/GTK/etc. on {Dar,Cyg}win.
    lib.optional (!(lib.lists.any (x: stdenv.hostPlatform.system == x) [ "i686-cygwin" ])) emacs;

  doCheck = true;

  meta = with lib; {
    description = "Tool to analyze the control flow of C programs";
    mainProgram = "cflow";

    longDescription = ''
      GNU cflow analyzes a collection of C source files and prints a
      graph, charting control flow within the program.

      GNU cflow is able to produce both direct and inverted flowgraphs
      for C sources.  Optionally a cross-reference listing can be
      generated.  Two output formats are implemented: POSIX and GNU
      (extended).

      The package also provides Emacs major mode for examining the
      produced flowcharts in Emacs.
    '';

    license = licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/cflow/";

    maintainers = [ ];

    platforms = platforms.linux ++ platforms.darwin;
  };
}
