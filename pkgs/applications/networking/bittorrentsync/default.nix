{ stdenv, fetchurl, patchelf }:

# this package contains the daemon version of bittorrent sync
# it's unfortunately closed source.

let
  # TODO: arm, ppc, osx

  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";
    
  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  version = "1.0.132";
  sha256 = if stdenv.system == "x86_64-linux" then "04mwzpbibzzbl384ziq07g7xxbc1rb5lyxgc7g8m1x5fvc6g1dk6"
    else if stdenv.system == "i686-linux" then "0yz1y761gx612lczlqjc3wddnw73qf4b8rna9hmfzan7ikqb81z0"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

in stdenv.mkDerivation {
  name = "btsync-bin-${version}";
  src = fetchurl {
    url = "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".";

  installPhase = ''
    ensureDir "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} \
      "$out/bin/btsync"
  '';

  buildInputs = [ patchelf ];

  meta = {
    homepage = "http://labs.bittorrent.com/experiments/sync.html";
    description = "Automatically sync files via secure, distributed technology.";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
