{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "1ldhi0ydpxdbpd0ak5c3zv93wif5sqsgfj4ggav2b0djm76al2gb"
    else if stdenv.system == "i686-linux" then "1fhki13isw3g7785b5jdl4warayg94ihah6wsr5h9gljjjghgi1c"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "2.2.7";

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
