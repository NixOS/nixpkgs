{stdenv, fetchurl, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

stdenv.mkDerivation (rec {
  name = "prooftree-${version}";
  version = "0.12";

  src = fetchurl {
    url = "http://askra.de/software/prooftree/releases/prooftree-${version}.tar.gz";
    sha256 = "08yp66j05pdkdpv9xkfqymqy82mir5xbwfh9mkzhh219xkps4b4m";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  dontAddPrefix = true;
  configureFlags = [ "--prefix" "$(out)" ];

  meta = {
    description = "Prooftree is a program for proof-tree visualization";
    longDescription = ''
      Prooftree is a program for proof-tree visualization during interactive
      proof development in a theorem prover. It is currently being developed
      for Coq and Proof General. Prooftree helps against getting lost between
      different subgoals in interactive proof development. It clearly shows
      where the current subgoal comes from and thus helps in developing the
      right plan for solving it.

      Prooftree uses different colors for the already proven subgoals, the
      current branch in the proof and the still open subgoals. Sequent texts
      are not displayed in the proof tree itself, but they are shown as a
      tool-tip when the mouse rests over a sequent symbol. Long proof commands
      are abbreviated in the tree display, but show up in full length as
      tool-tip. Both, sequents and proof commands, can be shown in the display
      below the tree (on single click) or in a separate window (on double or
      shift-click).
    '';
    homepage = http://askra.de/software/prooftree;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
})
