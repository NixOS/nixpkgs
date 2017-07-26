{ stdenv, fetchFromGitHub
, espeak, alsaLib, perl
, python }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "direwolf-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    rev = version;
    sha256 = "1x6vvl3fy70ic5pqvqsyr0bkqwim8m9jaqnm5ls8z8i66rwq23fg";
  };

  buildInputs = [
    espeak perl python
  ] ++ (optional stdenv.isLinux alsaLib);

  patchPhase = ''
        substituteInPlace Makefile.* \
          --replace /usr/share $out/share

        substituteInPlace dwespeak.sh \
          --replace espeak ${espeak}/bin/espeak
        '';

  installPhase = ''
    mkdir -p $out/bin 
    make INSTALLDIR=$out install
    '';

  meta = {
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    # On the page: This page will be disappearing on October 8, 2015.
    homepage = https://github.com/wb2osz/direwolf/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.the-kenny ];
  };
}
