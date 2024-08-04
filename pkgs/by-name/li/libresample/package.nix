{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  ninja,
  pkg-config,
  libsndfile,
  libsamplerate,
}:

stdenv.mkDerivation {
  pname = "libresample";
  version = "0.1.4";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "minorninth";
    repo = "libresample";
    rev = "b556e9ab8c303190dd6411ee16292262453bc28e";
    hash = "sha256-mpa1vJfOUhMdcgEfEi+DfKO3535RDrFI7w/ZEDGYFAE=";
  };

  patches = [
    # Port build system to Meson
    # https://github.com/minorninth/libresample/pull/8
    (fetchpatch2 {
      url = "https://github.com/minorninth/libresample/commit/217b1e0c429003ce53b3eae53102fdca282b2e12.patch?full_index=1";
      hash = "sha256-OPJLbC+XiPgSWNocsY1b9XRbdPDAcBcUhrFKnsr4QcA=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ libsndfile ];

  checkInputs = [ libsamplerate ];

  doCheck = true;

  meta = {
    description = "Real-time library for sampling rate conversion library";
    homepage = "https://github.com/minorninth/libresample";
    # There is a little ambiguity around the relicensing from
    # LGPL-2.1-or-later; see
    # <https://github.com/minorninth/libresample/issues/6>.
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sander ];
    mainProgram = "resample-sndfile";
  };
}
