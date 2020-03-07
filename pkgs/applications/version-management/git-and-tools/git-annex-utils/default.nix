{ stdenv, fetchgit, autoconf, automake, libtool, gmp }:

stdenv.mkDerivation rec {
  pname = "git-annex-utils";
  version = "0.04-3-g531bb33";
  src = fetchgit {
    url = http://git.mysteryvortex.com/repositories/git-annex-utils.git;
    rev = "531bb33";
    sha256 = "1sv7s2ykc840cjwbfn7ayy743643x9i1lvk4cd55w9l052xvzj65";
  };
  buildInputs = [ autoconf automake libtool gmp ];
  preConfigure = "./autogen.sh";

  meta = {
    description = "gadu, a du like utility for annexed files";
    longDescription = ''
      This is a set of utilities that are handy to use with git-annex repositories.
      Currently there is only one utility gadu, a du like utility for annexed files.
    '';
    homepage = http://git-annex.mysteryvortex.com/git-annex-utils.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ woffs ];
    platforms = stdenv.lib.platforms.all;
  };
}
