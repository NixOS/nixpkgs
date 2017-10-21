{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "aacgain-1.9.0";

  src = fetchFromGitHub {
    owner = "mulx";
    repo = "aacgain";
    rev = "7c29dccd878ade1301710959aeebe87a8f0828f5";
    sha256 = "07hl432vsscqg01b6wr99qmsj4gbx0i02x4k565432y6zpfmaxm0";
  };

  hardeningDisable = [ "format" ];

  configurePhase = ''
    cd mp4v2
    ./configure

    cd ../faad2
    ./configure

    cd ..
    ./configure
  '';

  buildPhase = ''
    cd mp4v2
    make libmp4v2.la

    cd ../faad2
    make LDFLAGS=-static

    cd ..
    make
  '';

  installPhase = ''
    strip -s aacgain/aacgain
    install -vD aacgain/aacgain "$out/bin/aacgain"
  '';

  meta = {
    description = "ReplayGain for AAC files";
    homepage = https://github.com/mulx/aacgain;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.robbinch ];
  };
}
