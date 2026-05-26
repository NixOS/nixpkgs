{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buildtorrent";
  version = "0.8";

  src = fetchurl {
    url = "https://mathr.co.uk/blog/code/buildtorrent-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-6OJ2R72ziHOsVw1GwalompKwG7Z/WQidHN0IeE9wUtA=";
  };

  meta = {
    description = "Simple commandline torrent creator";
    homepage = "https://mathr.co.uk/blog/torrent.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "buildtorrent";
  };
})
