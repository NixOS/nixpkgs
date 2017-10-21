{ stdenv, fetchurl, version, sha256s, ... } @ args:

let
  arch = {
    "x86_64-linux" = "x64";
    "i686-linux" = "i386";
  }.${stdenv.system};
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in

stdenv.mkDerivation rec {
  name = "btsync-${version}";
  inherit version;

  src = fetchurl {
    # annoyingly, downloads for 1.4 and 2.3 do not follow the same URL layout; this is
    # a simple work-around, in place of overriding the url in the caller.
    urls = [
      "https://download-cdn.getsync.com/${version}/linux-${arch}/BitTorrent-Sync_${arch}.tar.gz"
      "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz"
    ];
    sha256 = sha256s.${stdenv.system};
  };

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  installPhase = ''
    install -D btsync "$out/bin/btsync"
    patchelf --interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = https://www.getsync.com/;
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ domenkozar thoughtpolice cwoac ];
  };
}
