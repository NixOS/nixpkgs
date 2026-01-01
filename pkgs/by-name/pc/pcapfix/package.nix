{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "pcapfix";
  version = "1.1.7";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/pcapfix-${version}.tar.gz";
    sha256 = "sha256-bL6/b5npdrGrdok5JK65DNh8MWUILRUmTBkz8POz4Ow=";
  };

  postPatch = ''sed -i "s|/usr|$out|" Makefile'';

<<<<<<< HEAD
  meta = {
    homepage = "https://f00l.de/pcapfix/";
    description = "Repair your broken pcap and pcapng files";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://f00l.de/pcapfix/";
    description = "Repair your broken pcap and pcapng files";
    license = licenses.gpl3;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pcapfix";
  };
}
