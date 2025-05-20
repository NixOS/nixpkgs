{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  installCompatHeader ? false,
  installLegacyHeaders ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gsl-lite";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "gsl-lite";
    repo = "gsl-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9mvbD7zVTtfFRy2qIYJpU9XAlAW4ZLh5DE3WPEQpf38=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSL_LITE_OPT_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "GSL_LITE_OPT_INSTALL_COMPAT_HEADER" installCompatHeader)
    (lib.cmakeBool "GSL_LITE_OPT_INSTALL_LEGACY_HEADERS" installLegacyHeaders)
  ];

  # Building tests is broken on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Single-file header-only version of ISO C++ GSL";
    longDescription = ''
      gsl-lite is a single-file header-only implementation of the C++ Core
      Guidelines Support Library originally based on Microsoft GSL and adapted
      for C++98, C++03. It also works when compiled as C++11, C++14, C++17,
      C++20.
    '';
    homepage = "https://github.com/gsl-lite/gsl-lite";
    changelog = "https://github.com/gsl-lite/gsl-lite/blob/${finalAttrs.src.rev}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.all;
  };
})
