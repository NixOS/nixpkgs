{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib }:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation {
  name = "spotify-0.4.9.302";

  src = fetchurl {
    url = http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-qt_0.4.9.302.g604b4fb-1_amd64.deb;
    sha256 = "1cghs3hwmqnd7g62g1h2bf3yvxgjq8b94vzhp1w9ysb5rswyjkyv";
  };

  buildInputs = [ dpkg ];

  unpackPhase = "true";
  
  installPhase =
    ''
      mkdir -p $out
      dpkg-deb -x $src $out
      mv $out/usr/* $out/
      rmdir $out/usr

      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath ${stdenv.lib.makeLibraryPath [ xlibs.libXScrnSaver qt4 alsaLib stdenv.gcc.gcc ]}:${stdenv.gcc.gcc}/lib64 \
        $out/bin/spotify
    ''; # */

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = https://www.spotify.com/download/previews/;
    description = "Spotify for Linux allows you to play music from the Spotify music service";
    license = "unfree";
  };
}
