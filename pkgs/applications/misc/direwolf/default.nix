{ stdenv, fetchFromGitHub, unzip, alsaLib }:
let
  version = "1.2";
in
stdenv.mkDerivation rec {
  name = "direwolf-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    rev = "8b81a32";
    sha256 = "0r4fgdxghh292bzhqshr7zl5cg2lfsvlgmy4d5vqcli7x6qa1gcs";
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
    description = "A Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    # On the page: This page will be disappearing on October 8, 2015.
    homepage = https://home.comcast.net/~wb2osz/site/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
