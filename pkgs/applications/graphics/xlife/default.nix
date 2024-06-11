{ lib, stdenv, fetchsvn, xorg }:

stdenv.mkDerivation {
  pname = "xlife";
  version = "6.7.5";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xlife-cal/xlife/trunk";
    rev = "365";
    sha256 = "1gadlcp32s179kd7ypxr8cymd6s060p6z4c2vnx94i8bmiw3nn8h";
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
