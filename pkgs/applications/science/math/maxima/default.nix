{ stdenv, fetchurl, sbcl, texinfo, perl, makeWrapper, rlwrap ? null, tk ? null, gnuplot ? null }:

let
  name    = "maxima";
  version = "5.31.3";

  searchPath =
    stdenv.lib.makeSearchPath "bin"
      (stdenv.lib.filter (x: x != null) [ sbcl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "1g959569plywqaxxp488ylblgkirqg24arwa93dplfxi4h7fc4km";
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

  # Failures in the regression test suite are not going to abort the
  # build process. We run the suite mostly so that potential errors show
  # up in the build log. See also:
  # <http://sourceforge.net/tracker/?func=detail&aid=3365831&group_id=4933&atid=104933>.
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Maxima computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = "GPLv2";

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
