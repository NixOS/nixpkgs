{ lib
, stdenv
, fetchurl
, pkg-config
, libX11
, gtk2
, fig2dev
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "chemtool";
  version = "1.6.14";

  src = fetchurl {
    url = "http://ruby.chemie.uni-freiburg.de/~martin/${pname}/${pname}-${version}.tar.gz";
    sha256 = "hhYaBGE4azNKX/sXzfCUpJGUGIRngnL0V0mBNRTdr8s=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [
    libX11
    gtk2
    fig2dev
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ fig2dev ]}")
  '';

  meta = with lib; {
    homepage = "http://ruby.chemie.uni-freiburg.de/~martin/chemtool/";
    description = "Draw chemical structures";
    longDescription = ''
      Chemtool is a program for drawing organic molecules. It runs under the X
      Window System using the GTK widget set.

      Most operations in chemtool can be accomplished using the mouse - the
      first (usually the left) button is used to select or place things, the
      middle button modifies properties (e.g. reverses the direction of a bond),
      and the right button is used to delete objects.

      The program offers essentially unlimited undo/redo, two text fonts plus
      symbols, seven colors, drawing at several zoom scales, and square and
      hexagonal backdrop grids for easier alignment.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
