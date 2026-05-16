{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspecbleach";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "libspecbleach";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-s8eHryJfLz63m08O7l3r2iXOAgFqiuVTEcD774C3iXE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    fftwFloat
  ];

  meta = {
    description = "C library for audio noise reduction";
    homepage = "https://github.com/lucianodato/libspecbleach";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.unix;
  };
})
