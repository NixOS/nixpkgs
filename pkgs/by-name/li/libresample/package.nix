{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libsndfile,
  libsamplerate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libresample";
  version = "0.1.4-unstable-2024-08-23";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "minorninth";
    repo = "libresample";
    rev = "7cb7f9c3f72d4e6774d964dc324af827192df7c3";
    hash = "sha256-8gyGZVblqeHYXKFM79AcfX455+l3Tsoq3xQse5nrKAo=";
  };

  patches = [
    # Fix testresample.c output span; add exit code
    # https://github.com/minorninth/libresample/pull/7
    ./fix-test.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      # For `resample-sndfile`
      libsndfile
    ]
    ++ lib.optionals (!libsamplerate.meta.broken) [
      # For `compareresample`
      libsamplerate
    ];

  mesonFlags = [ (lib.mesonEnable "compareresample" (!libsamplerate.meta.broken)) ];

  doCheck = true;

  meta = {
    description = "Real-time library for sampling rate conversion library";
    homepage = "https://github.com/minorninth/libresample";
    license = lib.licenses.bsd2; # OR LGPL-2.1-or-later
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.sander
      lib.maintainers.emily
    ];
    mainProgram = "resample-sndfile";
  };
})
