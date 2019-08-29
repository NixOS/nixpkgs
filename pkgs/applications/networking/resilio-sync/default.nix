{ stdenv, fetchurl, ... }:

let
  arch = {
    "x86_64-linux" = "x64";
    "i686-linux" = "i386";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

in stdenv.mkDerivation rec {
  name = "resilio-sync-${version}";
  version = "2.6.3";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "114k7dsxn7lzv6mjq9alsqxypvkah4lmjn5w6brbvgd6m6pdwslz";
      "i686-linux"   = "1dh0hxbd33bs51xib3qwxw58h9j30v0dc10b4x4rwkbgsj11nc83";
    }.${stdenv.hostPlatform.system};
  };

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  installPhase = ''
    install -D rslsync "$out/bin/rslsync"
    patchelf \
      --interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/rslsync"
  '';

  meta = with stdenv.lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = https://www.resilio.com/;
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ domenkozar thoughtpolice cwoac ];
  };
}
