{ stdenv, fetchurl, ... }:

let
  arch = {
    "x86_64-linux" = "x64";
    "i686-linux" = "i386";
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

in stdenv.mkDerivation rec {
  name = "resilio-sync-${version}";
  version = "2.5.12";

  src = fetchurl {
    url = "https://download-cdn.resilio.com/${version}/linux-${arch}/resilio-sync_${arch}.tar.gz";
    sha256 = {
      "x86_64-linux" = "176gf5704wh22kqig8n0gg83048w71grw7h37k2qvxjaf4vypnc7";
      "i686-linux"   = "15m2s2cqrkpb7ladbwimbs9agqb4ww9jr4gf0ifjwzm2grv5ffnh";
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
