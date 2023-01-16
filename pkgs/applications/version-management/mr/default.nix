{ lib, stdenv, fetchgit, perl }:

stdenv.mkDerivation {
  pname = "mr";
  version = "1.20230114";

  src = fetchgit {
    url = "git://myrepos.branchable.com/";
    # the repository moved its tags at least once
    # when updating please continue using the revision hash here
    rev = "7196c47ed91ea188eed86c8da2eeddafee9cb2ed";
    sha256 = "sha256-+R1wijdFRftsLUGVj37pmAzEfuj1gzcuuU3wdjREsLI=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

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
    homepage = "http://myrepos.branchable.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ antono henrytill ];
  };
}
