{ stdenv, fetchurl, taskwarrior, perl, ncurses }:

stdenv.mkDerivation rec {
  version = "0.8";
  name = "tasknc-${version}";

  src = fetchurl {
    url = "https://github.com/mjheagle8/tasknc/archive/v${version}.tar.gz";
    sha256 = "0max5schga9hmf3vfqk2ic91dr6raxglyyjcqchzla280kxn5c28";
  };

  hardeningDisable = [ "format" ];

  #
  # I know this is ugly, but the Makefile does strange things in this package,
  # so we have to:
  #
  #   1. Remove the "doc" task dependency from the "all" target
  #   2. Remove the "tasknc.1" task dependency from the "install" target
  #   3. Remove the installing of the tasknc.1 file from the install target as
  #      we just removed the build target for it.
  #
  # TODO : One could also provide a patch for the doc/manual.pod file so it
  # actually builds, but I'm not familiar with this, so this is the faster
  # approach for me. We have no manpage, though.
  #
  preConfigure = ''
    sed -i -r 's,(all)(.*)doc,\1\2,' Makefile
    sed -i -r 's,(install)(.*)tasknc\.1,\1\2,' Makefile
    sed -i -r 's,install\ -D\ -m644\ tasknc\.1\ (.*),,' Makefile
  '';

  installPhase = ''
    mkdir $out/bin/ -p
    mkdir $out/share/man1 -p
    mkdir $out/share/tasknc -p
    DESTDIR=$out PREFIX= MANPREFIX=share make install
  '';

  buildInputs = [ taskwarrior perl ncurses ];

  meta = {
    homepage = https://github.com/mjheagle8/tasknc;
    description = "A ncurses wrapper around taskwarrior";
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.linux; # Cannot test others
  };
}
