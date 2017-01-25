{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.20151229-1";
  name = "vcsh-${version}";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/archive/v${version}.tar.gz";
    sha256 = "0wgg5zz11ql2v37vby5gbqvnbs80g1q83b9qbvm8d2pqx8bsb0kn";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp vcsh $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Version Control System for $HOME";
    homepage = https://github.com/RichiH/vcsh;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ garbas ttuegel ];
    platforms = platforms.unix;
  };
}
