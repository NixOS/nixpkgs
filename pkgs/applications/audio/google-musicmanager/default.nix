{ stdenv, fetchurl, readline, patchelf, ncurses, qt48, libidn, expat, flac
, libvorbis }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "1686-linux";

stdenv.mkDerivation rec {
  debversion = "beta_1.0.84.1107-r0";
  version = "1.0.84.1107-beta-r0"; # friendly to nix-env version sorting algo
  product = "google-musicmanager";
  name    = "${product}-${version}";

  # When looking for newer versions, since google doesn't let you list their repo dirs,
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/Release
  # fetch an appropriate packages file eg main/binary-amd64/Packages
  # which will contain the links to all available *.debs for the arch.

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = "http://dl.google.com/linux/musicmanager/deb/pool/main/g/${product}-beta/${product}-${debversion}_amd64.deb";
      sha256 = "0irlrspw508b1s9i5d1mddpp2x9w1ny3svf27gxf8pmwbiyd1cyi";
    }
    else fetchurl {
       url    = "http://dl.google.com/linux/musicmanager/deb/pool/main/g/${product}-beta/${product}-${debversion}_i386.deb";
       sha256 = "13pfsjvaygap6axrlbfhyk1h8377xmwi47x4af6j57qq6z7329rg";
    };

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.lzma
  '';

  buildInputs = [ patchelf ];

  buildPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "$out/opt/google/musicmanager:${readline}/lib:${ncurses}/lib:${stdenv.gcc.libc}/lib:${qt48}/lib:${stdenv.gcc.gcc}/lib:${libidn}/lib:${expat}/lib:${flac}/lib:${libvorbis}/lib" opt/google/musicmanager/MusicManager
  '';

  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    mkdir -p "$out"
    cp -r opt "$out"
    mkdir "$out/bin"
    ln -s "$out/opt/google/musicmanager/google-musicmanager" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Uploads music from your computer to Google Play";
    homepage    = "https://support.google.com/googleplay/answer/1229970";
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
