{stdenv, fetchgit}:

stdenv.mkDerivation {
  name = "vcsh-git";

  src = fetchgit {
    url = "https://github.com/RichiH/vcsh";
    rev = "75c4c554eefbefb714fabd356933858edbce3b1e";
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
    license = "GPLv2";
    platforms = stdenv.lib.platforms.unix;
  };
}
