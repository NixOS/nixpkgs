{ stdenv, fetchurl, sbcl, texinfo, perl, python, makeWrapper, rlwrap ? null,
tk ? null, gnuplot ? null, ecl ? null, ecl-fasl ? false
}:

let
  name    = "maxima";
  version = "5.39.0";

  searchPath =
    stdenv.lib.makeBinPath
      (stdenv.lib.filter (x: x != null) [ sbcl ecl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation ({
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "1cvignn5y6qzrby6qb885yc8zdcdqdr1d50vcvc3gapw2f0gk3zm";
  };

  buildInputs = stdenv.lib.filter (x: x != null)
    [sbcl ecl texinfo perl python makeWrapper];

  postInstall = ''
    # Make sure that maxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "$out/bin:${searchPath}"
    done
    # Move emacs modules and documentation into the right place.
    mkdir -p $out/share/emacs $out/share/doc
    ln -s ../maxima/${version}/emacs $out/share/emacs/site-lisp
    ln -s ../maxima/${version}/doc $out/share/doc/maxima
  ''
   + (stdenv.lib.optionalString ecl-fasl ''
     cp src/binary-ecl/maxima.fas* "$out/lib/maxima/${version}/binary-ecl/"
   '')
  ;

  # Failures in the regression test suite won't abort the build process. We run
  # the suite only so that potential errors show up in the build log. See also:
  # http://sourceforge.net/tracker/?func=detail&aid=3365831&group_id=4933&atid=104933.
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
    broken = ecl != null;
  };
} // (stdenv.lib.optionalAttrs ecl-fasl {
  preConfigure = ''
    sed -e '/c::build-program "binary-ecl\/maxima"/i(c::build-fasl "binary-ecl\/maxima.fasl" :lisp-files obj :ld-flags (let ((x (symbol-value (find-symbol "*AUTOCONF-LD-FLAGS*" (find-package "MAXIMA"))))) (if (and x (not (string= x ""))) (list x))))' -i src/maxima.system
  '';
}))
