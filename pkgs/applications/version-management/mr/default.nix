{ stdenv, fetchgit, perl }:

stdenv.mkDerivation rec {
  version = "1.20170129";
  name = "mr-${version}";

  src = fetchgit {
    url = "git://myrepos.branchable.com/";
    rev = "refs/tags/" + version;
    sha256 = "15i9bs2i25l7ibv530ghy8280kklcgm5kr6j86s7iwcqqckd0czp";
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
