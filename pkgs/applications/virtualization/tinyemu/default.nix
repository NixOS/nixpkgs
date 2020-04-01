{ stdenv, fetchurl, openssl, curl, SDL }:

stdenv.mkDerivation rec {
  pname = "tinyemu";
  version = "2018-09-23";
  src = fetchurl {
    url = "https://bellard.org/tinyemu/${pname}-${version}.tar.gz";
    sha256 = "0d6payyqf4lpvmmzvlpq1i8wpbg4sf3h6llsw0xnqdgq3m9dan4v";
  };
  buildInputs = [ openssl curl SDL ];
  makeFlags = [ "DESTDIR=$(out)" "bindir=/bin" ];
  preInstall = ''
    mkdir -p "$out/bin"
  '';
  meta = {
    homepage = "https://bellard.org/tinyemu/";
    description = "A system emulator for the RISC-V and x86 architectures";
    longDescription = "TinyEMU is a system emulator for the RISC-V and x86 architectures. Its purpose is to be small and simple while being complete.";
    license = with stdenv.lib.licenses; [ mit bsd2 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jhhuh ];
  };
}
