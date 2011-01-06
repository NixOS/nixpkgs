{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let version = "0.4.9.302"; in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-qt_${version}.g604b4fb-1_i386.deb";
        sha256 = "1kw3jfvz8a9v6zl3yh6f51vsick35kmcf7vkbjb6wl0nk1a8q8gg";
      }
    else if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-qt_${version}.g604b4fb-1_amd64.deb";
        sha256 = "1cghs3hwmqnd7g62g1h2bf3yvxgjq8b94vzhp1w9ysb5rswyjkyv";
      }
    else throw "Spotify not supported on this platform.";

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
    maintainers = [ stdenv.lib.maintainers.eelco ];

    longDescription =
      ''
        Spotify is a digital music streaming service.  This package
        provides the Spotify client for Linux.  At present, it does not
        work with free Spotify accounts; it requires a Premium or
        Unlimited account.

        Currently, the Spotify client requires a symlink from
        /usr/share/spotify to its resources.  Thus, you should do
        something like:

          $ nix-env -i spotify
          $ mkdir -p /usr/share
          $ ln -s ~/.nix-profile/share/spotify /usr/share/
      '';
  };
}
