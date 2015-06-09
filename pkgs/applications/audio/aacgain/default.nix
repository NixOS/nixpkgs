{ stdenv, fetchgit, unzip, m4, libtool, automake, autoconf, mp3gain, mp4v2, faad2 }:

stdenv.mkDerivation {
  name = "aacgain-1.9";
  srcs = [
    (fetchgit {
      url = "https://github.com/mecke/aacgain.git";
      rev = "4a7d59d78eadbbd5413e905af8f91fe9184ce7a8";
      sha256 = "0y25avgmm1xpbggvkhby1a7v9wmhsp3wmp74q06sf8ph8xsfajw4";
    })
    mp3gain.src
    mp4v2.src
    faad2.src
  ];

  buildInputs = [ unzip m4 libtool automake autoconf ];

  setSourceRoot = "sourceRoot=`pwd`";

  postUnpack = ''
    cd $sourceRoot
    # mp3gain does not unzip to its own directory, so move files accordingly.
    mkdir mp3gain
    find . -type f -maxdepth 1 -exec mv {} mp3gain/ \;
    mv mpglibDBL mp3gain/

    mv aacgain-* aacgain
    mv faad2-* faad2
    mv mp4v2-* mp4v2
  '';

  patchPhase = ''
    cd $sourceRoot
    patch -p2 -N < aacgain/linux/mp3gain.patch
  '';

  configurePhase = ''
    cd $sourceRoot/mp4v2
    ./configure

    cd $sourceRoot/faad2
    ./configure
  '';

  buildPhase = ''
    cd $sourceRoot/mp4v2
    make libmp4v2.la

    cd $sourceRoot/faad2/libfaad
    make

    cd $sourceRoot/aacgain/linux
    sh prepare.sh
    mkdir build
    cd build
    ../../../configure
    make
  '';

  installPhase = ''
    strip -s aacgain/aacgain
    install -vD aacgain/aacgain "$out/bin/aacgain"
  '';

  meta = {
    description = "ReplayGain for AAC files";
    homepage = https://github.com/mecke/aacgain.git;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.robbinch ];
  };
}
