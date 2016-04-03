{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "qboot-pre-release";

  src = fetchgit {
    url = "https://github.com/yangchengwork/qboot";
    rev = "b2bdaf4c878ef34f309c8c79613fabd1b9c4bf75";
    sha256 = "00f24125733d24713880e430f409d6ded416286d209c9fabb45541311b01cf8d";
  };

  installPhase = ''
    mkdir -p $out
    cp bios.bin* $out/.
  '';

  hardeningDisable = [ "stackprotector" "pic" ];

  meta = {
    description = "A simple x86 firmware for booting Linux";
    homepage = https://github.com/bonzini/qboot;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
}
