{ stdenv, fetchurl, readline, patchelf, ncurses, qt48, libidn, expat, flac
, libvorbis }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "1686-linux";
let
  archUrl = name: arch: "http://dl.google.com/linux/musicmanager/deb/pool/main/g/google-musicmanager-beta/${name}_${arch}.deb";
in
stdenv.mkDerivation rec {
  version = "beta_1.0.182.3607-r0"; # friendly to nix-env version sorting algo
  product = "google-musicmanager";
  name    = "${product}-${version}";

  # When looking for newer versions, since google doesn't let you list their repo dirs,
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/Release
  # fetch an appropriate packages file eg main/binary-amd64/Packages
  # which will contain the links to all available *.debs for the arch.

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = archUrl name "amd64";
      sha256 = "141x986haxg3r72ggh8prz0qg298jkad1ys8sdvsac92p4adcqx4";
    }
    else fetchurl {
        url    = archUrl name "i386";
        sha256 = "076iaa7pxhj8b1hlg5ah9jfm4qgzgjc9ivvg2l18wp045gnycv1l";
    };

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.lzma
  '';

  buildInputs = [ patchelf ];

  buildPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/opt/google/musicmanager:${readline}/lib:${ncurses}/lib:${stdenv.cc.libc}/lib:${qt48}/lib:${stdenv.cc.cc}/lib:${libidn}/lib:${expat}/lib:${flac}/lib:${libvorbis}/lib" opt/google/musicmanager/MusicManager
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
