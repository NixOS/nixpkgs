{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "1x95pag8ncjx3svm4424fjk5nmbdg8m87fsxy9sc63ba3qs9645j"
    else if stdenv.system == "i686-linux" then "0l8d85ib6kbpz5sh9v0qga03i4xph61iiy9xlhazm9h30d5a6l8v"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "1.3.77";

  src  = fetchurl {
    url  = "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";
  buildInputs = [ patchelf ];

  installPhase = ''
    ensureDir "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = "http://www.bittorrent.com/sync";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice ];
  };
}
