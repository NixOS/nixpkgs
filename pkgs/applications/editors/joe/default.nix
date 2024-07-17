{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "joe";
  version = "4.6";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${pname}-${version}.tar.gz";
    sha256 = "1pmr598xxxm9j9dl93kq4dv36zyw0q2dh6d7x07hf134y9hhlnj9";
  };

  meta = with lib; {
    description = "Full featured terminal-based screen editor";
    longDescription = ''
      JOE (Joe's Own Editor) is a full featured terminal-based screen editor
      which is distributed under the GNU General Public License (GPL). JOE has
      been around since 1988 and comes standard with many Linux distributions.

      JOE is being maintained by its original author Joseph Allen, plus all of
      the people who send bug reports, feature suggestions and patches to the
      project web site. JOE is hosted by SourceForge.net and its source code is
      controlled under Mercurial.

      JOE is a blending of MicroPro's venerable microcomputer word processor
      WordStar and Richard Stallman's famous LISP based text editor GNU-EMACS
      (but it does not use code from either program): most of the basic editing
      keys are the same as in WordStar as is the overall feel of the editor. JOE
      also has some of the key bindings and many of the powerful features of
      EMACS.

      JOE is written in C and its only dependency is libc. This makes JOE very
      easy to build (just "configure" and "make install"), making it feasible to
      include on small systems and recovery disks. The compiled binary is about
      300K in x86. Note that JOE can use either the termcap or terminfo terminal
      capabilities databases (or a built-in termcap entry for ANSI
      terminals). The choice is controlled by a "configure" option. If terminfo
      is used, a library is required to access the database (on some systems
      this library is ncurses, but JOE does not use curses to control the
      terminal - it has its own code for this).
    '';
    homepage = "https://joe-editor.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
