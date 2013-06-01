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

  version = "1.0.134";
  sha256 = if stdenv.system == "x86_64-linux" then "1kyxiqjabqgsg7n0a8snh03axxzpniazp93shb2l1b6x0f7d24n7"
    else if stdenv.system == "i686-linux" then "02wb8pqcb1rk108r49cqyg7s14grmjnkr6p3068pkiwdwwgi8jak"
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
