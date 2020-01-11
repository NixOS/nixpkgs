{ stdenv, fetchFromGitHub
, espeak, alsaLib, perl
, python }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "direwolf";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    rev = version;
    sha256 = "033sffjs2dz48077hc58jr4lxxs8md1fyfh4lig6ib7pyigiv1y0";
  };

  buildInputs = [
    espeak perl python
  ] ++ (optional stdenv.isLinux alsaLib);

  postPatch = ''
    for i in Makefile.*; do
      substituteInPlace "$i" \
        --replace /usr/share $out/share
    done

    substituteInPlace dwespeak.sh \
      --replace espeak ${espeak}/bin/espeak
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';
  installFlags = [ "INSTALLDIR=$(out)" ];

  meta = {
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    homepage = https://github.com/wb2osz/direwolf/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.the-kenny ];
  };
}
