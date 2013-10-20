{ stdenv, fetchurl, readline, patchelf, ncurses, qt48, libidn, expat, flac
, libvorbis }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "1686-linux";

stdenv.mkDerivation rec {
  version = "beta_1.0.84.1107-r0";
  product = "google-musicmanager";
  name    = "${product}-${version}";

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = "http://dl.google.com/linux/musicmanager/deb/pool/main/g/${name}-beta/${product}-${version}_amd64.deb";
      sha256 = "0irlrspw508b1s9i5d1mddpp2x9w1ny3svf27gxf8pmwbiyd1cyi";
    }
    else fetchurl {
       url    = "https://dl.google.com/linux/direct/${product}-beta_current_i386.deb";
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
    homepage    = "https://support.google.com/googleplay/answer/1229970?hl=en-AU";
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
