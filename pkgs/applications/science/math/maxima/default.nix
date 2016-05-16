{ stdenv, fetchurl, sbcl, texinfo, perl, makeWrapper, rlwrap ? null, tk ? null, gnuplot ? null }:

let
  name    = "maxima";
  version = "5.36.1";

  searchPath =
    stdenv.lib.makeBinPath
      (stdenv.lib.filter (x: x != null) [ sbcl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "0x1rk659sn3cq0n5c90848ilzr1gb1wf0072fl6jhkdq00qgh2s0";
  };

  buildInputs = [sbcl texinfo perl makeWrapper];

  postInstall = ''
    # Make sure that maxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "$out/bin:${searchPath}"
    done
    # Move emacs modules and documentation into the right place.
    mkdir -p $out/share/emacs $out/share/doc
    ln -s ../maxima/${version}/emacs $out/share/emacs/site-lisp
    ln -s ../maxima/${version}/doc $out/share/doc/maxima
  '';

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
  };
}
