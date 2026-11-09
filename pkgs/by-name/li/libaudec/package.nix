{
  lib,
  stdenv,
  fetchFromGitHub,
  libsndfile,
  libsamplerate,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaudec";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "zrythm";
    repo = "libaudec";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8morbrq8zG+2N3ruMeJa85ci9P0wPQOfZ5H56diFEAo=";
  };

  buildInputs = [
    libsndfile
    libsamplerate
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Library for reading and resampling audio files";
    homepage = "https://www.zrythm.org";
    license = lib.licenses.agpl3Plus;
    mainProgram = "audec";
    platforms = lib.platforms.all;
  };
})
