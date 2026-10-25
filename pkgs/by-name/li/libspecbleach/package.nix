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
  version = "0.4.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "libspecbleach";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rZdlrsTeVNZ6hzUBe57fWx4NqQYL/MdVUiYmQUDeoJQ=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        '"libdir=\''${exec_prefix}/''${CMAKE_INSTALL_LIBDIR}\n"' \
        '"libdir=''${CMAKE_INSTALL_FULL_LIBDIR}\n"' \
      --replace-fail \
        '"includedir=\''${prefix}/''${CMAKE_INSTALL_INCLUDEDIR}\n"' \
        '"includedir=''${CMAKE_INSTALL_FULL_INCLUDEDIR}\n"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ fftwFloat ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_FFTW" true)
    (lib.cmakeBool "ENABLE_EXAMPLES" false)
    (lib.cmakeBool "SPECBLEACH_BUILD_EXTRAS" true)
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
