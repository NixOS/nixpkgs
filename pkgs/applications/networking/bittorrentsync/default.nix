{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "1xba0wv45w4kg84i5sywkfk44vj9wxkr7f1vga2mpz86j8vq25iy"
    else if stdenv.system == "i686-linux" then "10ml1wclix9236zcb4mh60hdm9vvfaarlb62z7fdrwk6ikqbm7fk"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "1.3.94";

  src  = fetchurl {
    url  = "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";
  buildInputs = [ patchelf ];

  installPhase = ''
    mkdir -p "$out/bin/"
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
