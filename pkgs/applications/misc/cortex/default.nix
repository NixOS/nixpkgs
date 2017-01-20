{ stdenv, fetchgit, python3 }:

stdenv.mkDerivation {
  name = "cortex-2015-08-23";

  src = fetchgit {
    url = "https://github.com/gglucas/cortex";
    rev = "ff10ff860479fe2f50590c0f8fcfc6dc34446639";
    sha256 = "0pa2kkkcnmf56d5d5kknv0gfahddym75xripd4kgszaj6hsib3zg";
  };

  buildInputs = [ stdenv python3 ];

  prePatch = ''
    substituteInPlace cortex --replace "/usr/bin/env python3" "${python3}/bin/python3"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cortex $out/bin/
    chmod +x $out/bin/cortex
  '';

  meta = with stdenv.lib; {
    homepage = "http://cortex.glacicle.org";
    description = "An ncurses reddit browser and monitor";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with platforms; unix;
  };

}
