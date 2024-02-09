{ stdenv, lib, fetchurl, cmake, perl, pkg-config
, gtk3, ncurses, darwin
}:

stdenv.mkDerivation rec {
  version = "0.80";
  pname = "putty";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${pname}-${version}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-IBPIOnIbF1NSnpCQ98ODDo/kyAoHDMznZFObrbP2cIE=";
  };

  nativeBuildInputs = [ cmake perl pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isUnix [
    gtk3 ncurses
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.libs.utmp;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/putty/";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };
}
