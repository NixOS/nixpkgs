{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  getopt,
  libjpeg,
  libpng12,
  giflib,
}:

stdenv.mkDerivation rec {
  pname = "fbv";
  version = "1.0b";

  src = fetchurl {
    url = "http://s-tech.elsat.net.pl/fbv/fbv-${version}.tar.gz";
    sha256 = "0g5b550vk11l639y8p5sx1v1i6ihgqk0x1hd0ri1bc2yzpdbjmcv";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/4a5bfe522ea5afd8203e804dc6a642d0871cd6dd/srcpkgs/fbv/patches/giflib-5.1.patch";
      sha256 = "00q1zcn92yvvyij68bnq0m1sr3a411w914f4nyp6mpz0j5xc6dc7";
    })
  ];

  patchFlags = [ "-p0" ];

  buildInputs = [
    getopt
    libjpeg
    libpng12
    giflib
  ];
  makeFlags = [ "LDFLAGS=-lgif" ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,man/man1}
  '';

  meta = with lib; {
    description = "View pictures on a linux framebuffer device";
    homepage = "http://s-tech.elsat.net.pl/fbv/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "fbv";
  };
}
