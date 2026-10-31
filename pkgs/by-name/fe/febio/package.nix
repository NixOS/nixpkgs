{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  cmake,
  ninja,
  zlib,
  mklSupport ? true,
  mkl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "FEBio";
  version = "4.13";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yre9GWWHGKSI0SaXtJ0d+dxqmtMfpBA6vm+b6XmAssg=";
  };

  patches = [
    # Let findLib() also pick up shared libraries, not just static ones,
    # so that MKL is found.
    (replaceVars ./fix-cmake.patch {
      so = stdenv.hostPlatform.extensions.sharedLibrary;
    })

    # Add <cstdint> and <algorithm> includes that recent libstdc++ versions no
    # longer pull in transitively.
    ./missing-includes.patch
  ];

  cmakeFlags = lib.optionals mklSupport [
    (lib.cmakeBool "USE_MKL" true)
    (lib.cmakeFeature "MKLROOT" "${mkl}")
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ zlib ] ++ lib.optionals mklSupport [ mkl ];

  meta = {
    description = "Software tool for nonlinear finite element analysis in biomechanics and biophysics";
    license = lib.licenses.mit;
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
