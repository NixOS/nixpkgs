{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  leptonica,
  zlib,
  libwebp,
  giflib,
  libjpeg,
  libpng,
  libtiff,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "jbig2enc";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "jbig2enc";
    rev = version;
    hash = "sha256-IAL4egXgaGmCilzcryjuvOoHhahyrfGWY68GBfXXgAM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    leptonica
    zlib
    libwebp
    giflib
    libjpeg
    libpng
    libtiff
  ];

  patches = [
    (fetchpatch {
      name = "fix-build-leptonica-1.83.patch";
      url = "https://github.com/agl/jbig2enc/commit/ea050190466f5336c69c6a11baa1cb686677fcab.patch";
      hash = "sha256-+kScjFgDEU9F7VOUNAhm2XBjGm49fzAH8hYhmTm8xv8=";
    })
  ];

  # We don't want to install this Python 2 script
  postInstall = ''
    rm "$out/bin/pdf.py"
  '';

  # This is necessary, because the resulting library has
  # /tmp/nix-build-jbig2enc/src/.libs before /nix/store/jbig2enc/lib
  # in its rpath, which means that patchelf --shrink-rpath removes
  # the /nix/store one.  By cleaning up before fixup, we ensure that
  # the /tmp/nix-build-jbig2enc/src/.libs directory is gone.
  preFixup = ''
    make clean
  '';

  meta = {
    description = "Encoder for the JBIG2 image compression format";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://github.com/agl/jbig2enc";
    mainProgram = "jbig2";
  };
}
