{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "xhyve-${version}";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/mist64/xhyve/archive/v${version}.tar.gz";
    sha256 = "0g1vknnh88kxc8aaqv3j9wqhq45mm9xxxbn1vcrypj3kk9991hrj";
  };

  # Don't use git to determine version
  buildFlags = ''
    CFLAGS=-DVERSION=\"${version}\"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/xhyve $out/bin
  '';

  meta = {
    description = "Lightweight Virtualization on OS X Based on bhyve";
    homepage = "https://github.com/mist64/xhyve";
    maintainers = [ lib.maintainers.lnl7 ];
    platforms = lib.platforms.darwin;
  };
}
