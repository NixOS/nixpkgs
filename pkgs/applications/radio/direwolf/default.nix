{ stdenv, fetchFromGitHub, cmake, alsaLib, espeak, glibc, gpsd
, hamlib, perl, python, udev }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "direwolf";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    rev = version;
    sha256 = "0xmz64m02knbrpasfij4rrq53ksxna5idxwgabcw4n2b1ig7pyx5";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    espeak gpsd hamlib perl python
  ] ++ (optionals stdenv.isLinux [alsaLib udev]);

  patches = [
    ./udev-fix.patch
  ];

  postPatch = ''
    substituteInPlace src/symbols.c \
      --replace /usr/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt \
      --replace /opt/local/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt
    substituteInPlace src/decode_aprs.c \
      --replace /usr/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt \
      --replace /opt/local/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt
    substituteInPlace scripts/dwespeak.sh \
      --replace espeak ${espeak}/bin/espeak
    substituteInPlace cmake/cpack/direwolf.desktop.in \
      --replace 'Terminal=false' 'Terminal=true' \
      --replace 'Exec=@APPLICATION_DESKTOP_EXEC@' 'Exec=direwolf' \
  '';

  meta = {
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    homepage = "https://github.com/wb2osz/direwolf/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lasandell ];
  };
}
