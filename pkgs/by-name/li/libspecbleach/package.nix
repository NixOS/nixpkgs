{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fftwFloat,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libspecbleach";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "libspecbleach";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l8qVSE8ZBb/IWDcN7wJALtOtjnXk6/FqjTi0xI6TlSk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ fftwFloat ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_FFTW" true)
    (lib.cmakeBool "ENABLE_EXAMPLES" false)
  ];

  meta = {
    description = "C library for audio noise reduction";
    homepage = "https://github.com/lucianodato/libspecbleach";
    changelog = "https://github.com/lucianodato/libspecbleach/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.unix;
  };
})
