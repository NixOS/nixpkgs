{ fetchurl, stdenv, dpkg, xlibs, qt4, alsaLib, makeWrapper }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let version = "0.6.1.309"; in

stdenv.mkDerivation {
  name = "spotify-${version}";

  src =
    if stdenv.system == "i686-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-qt_${version}.gb871a7d-1_i386.deb";
        sha256 = "01bavmv78vd3lxsinbls72v2sj8czbcwzdg6sc2f9yd5g7snb3im";
      }
    else if stdenv.system == "x86_64-linux" then 
      fetchurl {
        url = "http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-qt_${version}.gb871a7d-1_amd64.deb";
        sha256 = "13ki1pcpna7f5sxf1j2axww95c4kqhj0r1d11y98mfvzxxjqimjs";
      }
    else throw "Spotify not supported on this platform.";

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";
  
  installPhase =
    ''
      mkdir -p $out
      dpkg-deb -x $src $out
      mv $out/usr/* $out/
      rmdir $out/usr

      patchelf \
        --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath ${stdenv.lib.makeLibraryPath [ xlibs.libXScrnSaver xlibs.libX11 qt4 alsaLib stdenv.gcc.gcc ]}:${stdenv.gcc.gcc}/lib64 \
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
