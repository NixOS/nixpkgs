{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "1.20150503";
  name = "mr-${version}";

  src = fetchurl {
    url = "https://github.com/joeyh/myrepos/archive/${version}.tar.gz";
    sha256 = "12cf8kmn13446rszmah5wws5p2k2gjp6y4505sy1r14qnahf4qbf";
  };

  buildInputs = [ perl ];

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Multiple Repository management tool";
    longDescription = ''
      mr is a tool to manage all your version control repos. It can
      checkout, update, or perform other actions on a set of
      repositories as if they were one combined repository. It
      supports any combination of subversion, git, cvs, mercurial,
      bzr, darcs, fossil and veracity repositories, and support for
      other version control systems can easily be added.
    '';
    homepage = http://myrepos.branchable.com/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ antono henrytill ];
  };
}
