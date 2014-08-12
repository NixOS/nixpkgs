{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {

  version = "1.13";
  name = "mr-" + version;

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/m/mr/mr_${version}.tar.gz";
    sha256 = "1q3qxk8dwbv30v2xxh852wnwl1msgkvk5cgxyicpqj8kh5b96zlz";
  };

  buildInputs = [perl];

  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -pv $out/bin $out/share/man/man1 $out/share/mr
    cp -v mr $out/bin
    cp -v webcheckout $out/bin
    cp -v mr.1 $out/share/man/man1
    cp -v webcheckout.1 $out/share/man/man1
    cp -v lib/* $out/share/mr
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
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
