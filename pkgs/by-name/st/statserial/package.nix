{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  glibc,
}:

stdenv.mkDerivation rec {
  pname = "statserial";
  version = "1.1";

  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/system/serial/statserial-${version}.tar.gz";
    sha256 = "0rrrmxfba5yn836zlgmr8g9xnrpash7cjs7lk2m44ac50vakpks0";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-lcurses' '-lncurses'

    substituteInPlace Makefile \
      --replace 'LDFLAGS = -s -N' '#LDFLAGS = -s -N'
  '';

  buildInputs = [
    ncurses
    glibc
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp statserial $out/bin

    mkdir -p $out/share/man/man1
    cp statserial.1 $out/share/man/man1
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://sites.google.com/site/tranter/software";
    description = "Display serial port modem status lines";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    homepage = "https://sites.google.com/site/tranter/software";
    description = "Display serial port modem status lines";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    longDescription = ''
      Statserial displays a table of the signals on a standard 9-pin or
      25-pin serial port, and indicates the status of the handshaking lines. It
      can be useful for debugging problems with serial ports or modems.
    '';

<<<<<<< HEAD
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rps ];
=======
    platforms = platforms.unix;
    maintainers = with maintainers; [ rps ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "statserial";
  };
}
