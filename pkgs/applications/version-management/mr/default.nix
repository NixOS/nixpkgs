{ stdenv, fetchgit, perl }:

stdenv.mkDerivation rec {
  name = "mr-${version}";
  version = "1.20180726";

  src = fetchgit {
    url = "git://myrepos.branchable.com/";
    # the repository moved its tags at least once
    # when updating please continue using the revision hash here
    rev = "0ad7a17bb455de1fec3b2375c7aac72ab2a22ac4";
    sha256 = "0jphw61plm8cgklja6hs639xhdvxgvjwbr6jpvjwpp7hc5gmhms5";
  };

  postPatch = ''
    patchShebangs .
  '';

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
