{ stdenv, fetchurl, ... }:

let
  arch = {
    x86_64-linux = "x64";
    i686-linux = "i386";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

in stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "2.7.2";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz";
    sha256 = {
      x86_64-linux = "0gar5lzv1v4yqmypwqsjnfb64vffzn8mw9vnjr733fgf1pmr57hf";
      i686-linux   = "1bws7r86h1vysjkhyvp2zk8yvxazmlczvhjlcayldskwq48iyv6w";
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
    homepage    = "https://www.resilio.com/";
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ domenkozar thoughtpolice cwoac ];
  };
}
