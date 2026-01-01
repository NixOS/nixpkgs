{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "buildtorrent";
  version = "0.8";

  src = fetchurl {
    url = "https://mathr.co.uk/blog/code/${pname}-${version}.tar.gz";
    sha256 = "sha256-6OJ2R72ziHOsVw1GwalompKwG7Z/WQidHN0IeE9wUtA=";
  };

<<<<<<< HEAD
  meta = {
    description = "Simple commandline torrent creator";
    homepage = "https://mathr.co.uk/blog/torrent.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Simple commandline torrent creator";
    homepage = "https://mathr.co.uk/blog/torrent.html";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "buildtorrent";
  };
}
