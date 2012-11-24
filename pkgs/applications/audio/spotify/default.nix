{
  fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper, openssl, glib,
  freetype, gdk_pixbuf, gtk, cairo, pango, atk, nss
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let version = "0.8.4.103";
    
    revision = "g9cb177b.260-1";

in stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}.${revision}_i386.deb";
        sha256 = "1iri6pgavgb06nx0l3myqryx7zd7cf22my8vh2v6w4kbvaajjl31";
      }
    else if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${version}.${revision}_amd64.deb";
        sha256 = "0y5kyfa1gk16d9z67hgssam8hgzw6g5f7xsxk0lz3ak487xdwl6k";
      }
    else throw "Spotify not supported on this platform.";

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  libraryPath = stdenv.lib.makeLibraryPath [
    alsaLib freetype glib gdk_pixbuf gtk openssl qt4 stdenv.gcc.gcc
    xlibs.libX11 xlibs.libXScrnSaver cairo pango atk nss
  ];
  
  installPhase =
    ''
      mkdir -p $out
      dpkg-deb -x $src $out
      mv $out/usr/* $out/
      rmdir $out/usr

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.
      mkdir $out/lib
      ln -s ${openssl}/lib/libssl.so $out/lib/libssl.so.0.9.8
      ln -s ${openssl}/lib/libcrypto.so $out/lib/libcrypto.so.0.9.8
      ln -s ${nss}/lib/libnss3.so $out/lib/libnss3.so.1d

      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath $out/lib:$libraryPath:${stdenv.gcc.gcc}/lib64:$out/share/spotify \
        $out/bin/spotify

      preload=$out/libexec/spotify/libpreload.so
      mkdir -p $out/libexec/spotify
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC

      wrapProgram $out/bin/spotify --set LD_PRELOAD $preload
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
      '';
  };
}
