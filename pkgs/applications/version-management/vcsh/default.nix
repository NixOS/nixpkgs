{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.20141026-1";
  name = "vcsh-${version}";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/archive/v${version}.tar.gz";
    sha256 = "1wgrmkygsbmk8zj88kjx9aim2fc44hh2d1a83h4mn2j714pffh33";
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
