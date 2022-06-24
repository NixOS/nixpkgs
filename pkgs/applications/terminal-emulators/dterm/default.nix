{ lib
, stdenv
, fetchurl
, readline
}:

stdenv.mkDerivation rec {
  pname = "dterm";
  version = "0.5";

  src = fetchurl {
    url = "http://www.knossos.net.nz/downloads/dterm-${version}.tgz";
    hash = "sha256-lFM7558e7JZeWYhtXwCjXLZ1xdsdiUGfJTu3LxQKvds=";
  };

  buildInputs = [ readline ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'gcc' '${stdenv.cc.targetPrefix}cc'
  '';

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "BIN=$(out)/bin/" ];

  meta = with lib; {
    homepage = "http://www.knossos.net.nz/resources/free-software/dterm/";
    description = "A simple terminal program";
    longDescription = ''
      dterm is a simple terminal emulator, which doesn’t actually emulate any
      particular terminal. Mainly, it is designed for use with xterm and
      friends, which already do a perfectly good emulation, and therefore don’t
      need any special help; dterm simply provides a means by which keystrokes
      are forwarded to the serial line, and data forwarded from the serial line
      appears on the terminal.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ auchter ];
    platforms = platforms.unix;
  };
}
