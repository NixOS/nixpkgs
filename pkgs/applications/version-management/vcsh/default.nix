{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  rev = "75c4c554eefbefb714fabd356933858edbce3b1e";
  version = "1.20131229";
  name = "vcsh-${version}_${rev}";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/RichiH/vcsh";
    sha256 = "0rc82a8vnnk9q6q88z9s10873gqgdpppbpwy2yw8a7hydqrpn0hs";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp vcsh $out/bin
  '';

  meta = {
    description = "Version Control System for $HOME";
    homepage = https://github.com/RichiH/vcsh;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.unix;
  };
}
