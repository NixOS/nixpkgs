{ lib, stdenv, fetchsvn, xorg }:

stdenv.mkDerivation {
  pname = "xlife";
  version = "6.7.6";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xlife-cal/xlife/trunk";
    rev = "365";
    sha256 = "sha256-EFk7eKwLRZK63YKRby4wQJtWPUO5X3/aTCdoMS6jTb0=";
  };

  nativeBuildInputs = with xorg; [ imake gccmakedep ];
  buildInputs = [ xorg.libX11 ];

  hardeningDisable = [ "format" ];
  installPhase = ''
    install -Dm755 xlife -t $out/bin
    install -Dm755 lifeconv -t $out/bin
  '';

  meta = with lib; {
    homepage = "http://litwr2.atspace.eu/xlife.php";
    description = "Conway's Game of Life and other cellular automata, for X";
    license = licenses.hpndSellVariant;
    maintainers = with maintainers; [ djanatyn ];
  };
}
