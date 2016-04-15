{ stdenv, fetchurl, readline, patchelf, ncurses, qt48, libidn, expat, flac
, libvorbis }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";
let
  archUrl = name: arch: "http://dl.google.com/linux/musicmanager/deb/pool/main/g/google-musicmanager-beta/${name}_${arch}.deb";
in
stdenv.mkDerivation rec {
  version = "beta_1.0.243.1116-r0"; # friendly to nix-env version sorting algo
  product = "google-musicmanager";
  name    = "${product}-${version}";

  # When looking for newer versions, since google doesn't let you list their repo dirs,
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/Release
  # fetch an appropriate packages file such as main/binary-amd64/Packages:
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/main/binary-amd64/Packages
  # which will contain the links to all available *.debs for the arch.

  src = if stdenv.system == "x86_64-linux"
    then fetchurl {
      url    = archUrl name "amd64";
      sha256 = "54f97f449136e173492d36084f2c01244b84f02d6e223fb8a40661093e0bec7c";
    }
    else fetchurl {
        url    = archUrl name "i386";
        sha256 = "121a7939015e2270afa3f1c73554102e2b4f2e6a31482ff7be5e7c28dd101d3c";
    };

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.lzma
  '';

  buildInputs = [ patchelf ];

  buildPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/opt/google/musicmanager:${stdenv.lib.makeLibraryPath [ readline ncurses stdenv.cc.libc.out qt48 stdenv.cc.cc libidn expat flac libvorbis ]}" opt/google/musicmanager/MusicManager
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
