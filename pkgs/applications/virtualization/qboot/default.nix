{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "qboot-20170330";

  src = fetchFromGitHub {
    owner = "bonzini";
    repo = "qboot";
    rev = "ac9488f26528394856b94bda0797f5bd9c69a26a";
    sha256 = "0l83nbjndin1cbcimkqkiqr5df8d76cnhyk26rd3aygb2bf7cspy";
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
