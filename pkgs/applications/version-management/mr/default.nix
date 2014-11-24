{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "1.20141024";
  name = "mr-${version}";

  src = fetchurl {
    url = "https://github.com/joeyh/myrepos/archive/${version}.tar.gz";
    sha256 = "7b68183476867d15d6f111fc9678335b94824dcfa09f07c761a72d64cdf5ad4a";
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
