{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "xhyve-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/mist64/xhyve/archive/v${version}.tar.gz";
    sha256 = "0nbb9zy4iqmdz2dpyvcl1ynimrrpyd6f6cq8y2p78n1lmgqhrgkm";
  };

  buildFlags = "CFLAGS=-Wno-pedantic -Wno-shift-sign-overflow";

  installPhase = ''
    mkdir -p $out/bin
    cp build/xhyve $out/bin
  '';

  meta = {
    description = "Lightweight Virtualization on OS X Based on bhyve";
    homepage = "https://github.com/mist64/xhyve";
    maintainers = lib.maintainers.lnl7;
    platforms = lib.platforms.darwin;
  };
}
