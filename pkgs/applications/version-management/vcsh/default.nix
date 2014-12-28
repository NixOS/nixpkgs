{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  rev = "ef15aeeb0553efb698e3d4261e79eff77a136ee7";
  version = "1.20141026";
  name = "vcsh-${version}_${builtins.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/RichiH/vcsh";
    sha256 = "1dg6ina2wpy406s5x0x4r7khx6gc42hfak0gjwy0i53ivkckl1nd";
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
