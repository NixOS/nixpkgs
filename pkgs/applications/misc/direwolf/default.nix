{ stdenv, fetchurl, unzip, alsaLib }:
let
  version = "1.2";
in
stdenv.mkDerivation rec {
  name = "direwolf-${version}";
  inherit version;

  src = fetchurl {
    url = "http://home.comcast.net/~wb2osz/Version%201.2/direwolf-${version}-src.zip";
    sha256 = "0csl6harx7gmjmamxy0ylzhbamppphffisk8j33dc6g08k6rc77f";
  };

  buildInputs = [
    unzip alsaLib
  ];

  patchPhase = ''
    substituteInPlace Makefile.linux \
      --replace "/usr/local" "$out" \
      --replace "/usr/share" "$out/share"
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway.";
    # On the page: This page will be disappearing on October 8, 2015.
    homepage = https://home.comcast.net/~wb2osz/site/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
