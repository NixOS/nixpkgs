{ stdenv, fetchurl }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "01yrligi61gxcixh7z6gi427ga0sx97wnmkv08p9ykd4b90hvj7s"
    else if stdenv.system == "i686-linux" then     "119dll7f4w7h8nrrafmrj1d0lddjzwg5l8hnf74xdjg6g7rhrmd7"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "2.3.6";

  src  = fetchurl {
    url  = "https://download-cdn.getsync.com/${version}/linux-${arch}/BitTorrent-Sync_${arch}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";

  installPhase = ''
    mkdir -p "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = https://www.getsync.com/;
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice cwoac ];
  };
}
