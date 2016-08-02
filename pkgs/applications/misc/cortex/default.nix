{ stdenv, fetchgit, python3 }:

stdenv.mkDerivation {
  name = "cortex-2014-08-01";

  src = fetchgit {
    url = "https://github.com/gglucas/cortex";
    rev = "e749de6c21aae02386f006fd0401d22b9dcca424";
    sha256 = "d5d59c5257107344122c701eb370f3740f9957b6b898ac798d797a4f152f614c";
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
