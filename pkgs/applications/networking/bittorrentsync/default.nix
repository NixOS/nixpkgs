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

  version = "1.0.116";
  sha256 = if stdenv.system == "x86_64-linux" then "108c11x8lp0a4irq88raclz3zfvmkxsqymxx3y8amc1lc6kc3n8i"
    else if stdenv.system == "i686-linux" then "0kkxi04rggq6lrvn7g1xjay2nskqn7z4qkm0h0lcra7h2jz09mf1"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

in stdenv.mkDerivation {
  name = "btsync-bin-${version}";
  src = fetchurl {
    # TODO: using version-specific URL: http://forum.bittorrent.com/topic/18070-versioned-binary-downloads/#entry45868
    url = "http://btsync.s3-website-us-east-1.amazonaws.com/btsync_${arch}.tar.gz";
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
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
