{ stdenv, fetchurl, ... }:

let
  arch = {
    "x86_64-linux" = "x64";
    "i686-linux" = "i386";
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

in stdenv.mkDerivation rec {
  name = "resilio-sync-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "0041axi9carspkfaxvyirfvsa29zz55al01x90nh93nzxvpvywsz";
      "i686-linux"   = "1ar36lp4f6a1z9i82g3gpak4q4ny09faqxdd59q1pvfzq25ypdhs";
    }.${stdenv.system};
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
