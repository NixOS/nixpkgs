{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "9e1427b7a6c6e960a378b97ac458ad53c445457ed0e5c8bf693f446597377b78"
    else if stdenv.system == "i686-linux" then "4d446255ff6332da9a244737d6c20e7dcd32d24a8eaabffbaf73147e5898ed8f"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "2.0.105";

  src  = fetchurl {
    url  = "https://download-cdn.getsyncapp.com/${version}/linux-${arch}/BitTorrent-Sync_${arch}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";
  buildInputs = [ patchelf ];

  installPhase = ''
    mkdir -p "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = "http://www.bittorrent.com/sync";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice cwoac ];
  };
}
