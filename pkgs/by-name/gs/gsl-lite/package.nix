{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, installCompatHeader ? false
, installLegacyHeaders ? false
}:

stdenv.mkDerivation rec {
  pname = "gsl-lite";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "gsl-lite";
    repo = "gsl-lite";
    rev = "v${version}";
    hash = "sha256-cuuix302bVA7dWa7EJoxJ+otf1rSzjWQK8DHJsVkQio=";
  };

  patches = [
    (fetchpatch {
      name = "type-limits-cast-fix.patch";
      url = "https://github.com/gsl-lite/gsl-lite/commit/13475be0e5bf5f464c398f4a07ef5c7684bc57c5.patch";
      hash = "sha256-rSz7OBmgQ3KcQ971tS3Z3QNC+U4XmrPjgmuOyG7J6Bo=";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = lib.mapAttrsToList
    (name: value: ''-DGSL_LITE_OPT_${name}:BOOL=${if value then "ON" else "OFF"}'')
    {
      INSTALL_COMPAT_HEADER = installCompatHeader;
      INSTALL_LEGACY_HEADERS = installLegacyHeaders;
      BUILD_TESTS = doCheck;
    };

  # Building tests is broken on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = ''
      A single-file header-only version of ISO C++ Guidelines Support Library
      (GSL) for C++98, C++11, and later
    '';
    longDescription = ''
      gsl-lite is a single-file header-only implementation of the C++ Core
      Guidelines Support Library originally based on Microsoft GSL and adapted
      for C++98, C++03. It also works when compiled as C++11, C++14, C++17,
      C++20.
    '';
    homepage = "https://github.com/gsl-lite/gsl-lite";
    changelog = "https://github.com/gsl-lite/gsl-lite/blob/${src.rev}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
