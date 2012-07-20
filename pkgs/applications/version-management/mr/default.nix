{ stdenv, fetchgit, fetchgitrevision, perl }:

stdenv.mkDerivation rec {

  version = "1.12";
  name = "mr-" + version;

  src = fetchgit {
    url = "git://git.kitenet.net/mr.git";
    rev = "353f63c968368edea9b14261f510c34ce4e0c97f";
  };

  buildInputs = [perl];

  buildPhase = ''
    make build
  '';

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/share/man/man1
    cp mr $out/bin
    cp webcheckout $out/bin
    cp mr.1 $out/share/man/man1
    cp webcheckout.1 $out/share/man/man1
  '';
      
  meta = {
    description = "Multiple Repository management tool";
    longDescription = ''The mr(1) command can checkout, update, or perform other actions on a
      set of repositories as if they were one combined respository. It
      supports any combination of subversion, git, cvs, mercurial, bzr,
      darcs, cvs, vcsh, fossil and veracity repositories, and support for
      other revision control systems can easily be added. (There are
      extensions adding support for unison and git-svn.)

      It is extremely configurable via simple shell scripting. Some examples
      of things it can do include:

        - Update a repository no more frequently than once every twelve
          hours.
        - Run an arbitrary command before committing to a
          repository.
        - When updating a git repository, pull from two
          different upstreams and merge the two together.
        - Run several repository updates in parallel, greatly speeding
          up the update process.
        - Remember actions that failed due to a laptop being
          offline, so they can be retried when it comes back online.
    '';
    homepage = http://joeyh.name/code/mr/;
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
 
