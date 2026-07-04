{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cimg,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pHash";
  version = "0.9.6";

  buildInputs = [ cimg ];

  # CImg.h calls to external binary `convert` from the `imagemagick` package
  # at runtime
  propagatedBuildInputs = [ imagemagick ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--enable-video-hash=no"
    "--enable-audio-hash=no"
  ];
  postInstall = ''
    cp ${cimg}/include/CImg.h $out/include/
  '';

  src = fetchFromGitHub {
    owner = "clearscene";
    repo = "pHash";
    rev = finalAttrs.version;
    sha256 = "sha256-frISiZ89ei7XfI5F2nJJehfQZsk0Mlb4n91q/AiZ2vA=";
  };

  env.NIX_LDFLAGS = "-lfftw3_threads";

  patches = [
    # proper pthread return value (https://github.com/clearscene/pHash/pull/20)
    ./0001-proper-pthread-return-value.patch
  ];

  meta = {
    description = "Compute the perceptual hash of an image";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.imalsogreg ];
    platforms = lib.platforms.all;
    homepage = "http://www.phash.org";
    downloadPage = "https://github.com/clearscene/pHash";
  };
})
