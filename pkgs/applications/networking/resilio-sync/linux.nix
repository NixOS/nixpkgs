{ stdenv
, lib
, pname
, version
, src
, meta
, libxcrypt
}:

stdenv.mkDerivation {
  inherit pname version src meta;

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  installPhase = ''
    install -D rslsync "$out/bin/rslsync"
    patchelf \
      --interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath [ stdenv.cc.libc libxcrypt ]} "$out/bin/rslsync"
  '';
}
