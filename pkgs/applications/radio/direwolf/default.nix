{ stdenv, fetchFromGitHub
, alsaLib, espeak, glibc, gpsd
, hamlib, perl, python, udev }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "direwolf";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    rev = version;
    sha256 = "1w55dv9xqgc9mpincsj017838vmvdy972fhis3ddskyfvhhzgcsk";
  };

  buildInputs = [
    espeak gpsd hamlib perl python
  ] ++ (optionals stdenv.isLinux [alsaLib udev]);

  makeFlags = [ "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace symbols.c \
      --replace /usr/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt \
      --replace /opt/local/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt
    substituteInPlace decode_aprs.c \
      --replace /usr/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt \
      --replace /opt/local/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt
    substituteInPlace dwespeak.sh \
      --replace espeak ${espeak}/bin/espeak
  '' + (optionalString stdenv.isLinux ''
    substituteInPlace Makefile.linux \
      --replace /usr/include/pthread.h ${stdenv.glibc.dev}/include/pthread.h \
      --replace /usr/include/alsa ${alsaLib.dev}/include/alsa \
      --replace /usr/include/gps.h ${gpsd}/include/gps.h \
      --replace /usr/include/hamlib ${hamlib}/include/hamlib \
      --replace /usr/include/libudev.h ${udev.dev}/include/libudev.h \
      --replace /etc/udev $out/etc/udev \
      --replace 'Exec=xterm -hold -title \"Dire Wolf\" -bg white -e \"$(DESTDIR)/bin/direwolf\"' "Exec=$out/bin/direwolf" \
      --replace '#Terminal=true' 'Terminal=true' \
      --replace 'Path=$(HOME)' '#Path='
  '');

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    homepage = "https://github.com/wb2osz/direwolf/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lasandell ];
  };
}
