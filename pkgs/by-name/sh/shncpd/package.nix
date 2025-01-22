{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "shncpd";
  version = "2016-06-22";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "shncpd";
    rev = "62ef688db7a6535ce11e66c8c93ab64a1bb09484";
    sha256 = "1sj7a77isc2jmh7gw2naw9l9366kjx6jb909h7spj7daxdwvji8f";
  };

  hardeningEnable = [ "pie" ];

  preConfigure = ''
    makeFlags=( "PREFIX=$out" )
  '';

  meta = with lib; {
    description = "Simple, stupid and slow HNCP daemon";
    homepage = "https://www.irif.univ-paris-diderot.fr/~jch/software/homenet/shncpd.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.fpletz ];
    mainProgram = "shncpd";
  };
}
