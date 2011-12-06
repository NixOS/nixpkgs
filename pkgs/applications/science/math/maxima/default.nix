{ stdenv, fetchurl, sbcl, texinfo, perl, makeWrapper, rlwrap ? null, tk ? null, gnuplot ? null }:

let
  name    = "maxima";
  version = "5.25.1";

  searchPath =
    stdenv.lib.makeSearchPath "bin"
      (stdenv.lib.filter (x: x != null) [ sbcl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "8e98ad742151e52edb56337bd62c8a9749f7b598cb6ed4e991980e0e6f89706a";
  };

  buildInputs = [sbcl texinfo perl makeWrapper];

  postInstall = ''
    # Make sure that maxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "${searchPath}"
    done
    # Move emacs modules and documentation into the right place.
    ensureDir $out/share/emacs $out/share/doc
    ln -s ../maxima/${version}/emacs $out/share/emacs/site-lisp
    ln -s ../maxima/${version}/doc $out/share/doc/maxima
  '';

  # The regression test suite has minor failures, but curiously enough
  # this doesn't seem to abort the build process:
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
