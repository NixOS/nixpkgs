{ stdenv, fetchurl, x11, xextproto, libXtst, inputproto, libXi
, automake, autoconf, sourceFromHead }:

stdenv.mkDerivation {
  name = "synergy-cvs";

  # note: There is a fork:
  # http://code.google.com/p/synergy-plus

  # REGION AUTO UPDATE:            { name="synergy"; type = "cvs"; cvsRoot = ":pserver:anonymous@synergy2.cvs.sourceforge.net:/cvsroot/synergy2"; module="syngery"; }
  src= sourceFromHead "synergy-F_23-55-02.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/synergy-F_23-55-02.tar.gz"; sha256 = "ae16a9b59039a32e383e71397405d7b610de6c6902c03177c2496bac440d3e28"; });
  # END

  buildInputs = [ x11 xextproto libXtst inputproto libXi automake autoconf ];

  preConfigure = "autoreconf";

  patches =
    [ (fetchurl {
        url = http://mawercer.de/~nix/synergy-gcc43-r2.patch.gz;
        sha256 = "0wnj5k93ybj7jg8ml1i1brwsnszfh41117q2qh7r8xr9m37997b7";
      })
    ];

  meta = { 
    description = "Tool to share the mouse keyboard and the clipboard between computers";
    homepage = http://synergy2.sourceforge.net;
    license = "GPL";
  };
}
