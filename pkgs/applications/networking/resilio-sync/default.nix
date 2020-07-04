{ stdenv, fetchurl, ... }:

let
  arch = {
    x86_64-linux = "x64";
    i686-linux = "i386";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

in stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "2.7.1";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz";
    sha256 = {
      x86_64-linux = "1gdjpwdg7cpig68wsl3b8w1y12391dh5ipg7g19kr30s6wr3avvm";
      i686-linux   = "1b6pzckaixfzhjf38amrkg8pahh2p3jg6cgfacswdx7cjb4a0c4i";
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
