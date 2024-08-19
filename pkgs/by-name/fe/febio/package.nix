{
  lib,
  stdenv,
  overrideSDK,
  fetchFromGitHub,
  fetchpatch2,
  substituteAll,
  cmake,
  ninja,
  zlib,
  darwin,
  mklSupport ? true,
  mkl,
}:

let
  stdenv' = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in

stdenv'.mkDerivation (finalAttrs: {
  pname = "FEBio";
  version = "4.7";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RRdIOyXg4jYW76ABfJdMfVtCYMLYFdvyOI98nHXCof8=";
  };

  patches = [
    # Fix library searching and installation
    (substituteAll {
      src = ./fix-cmake.patch;
      so = stdenv.hostPlatform.extensions.sharedLibrary;
    })

    # Fixed missing header include for strcpy
    # https://github.com/febiosoftware/FEBio/pull/92
    (fetchpatch2 {
      url = "https://github.com/febiosoftware/FEBio/commit/ad9e80e2aa8737828855458a703822f578db2fd3.patch?full_index=1";
      hash = "sha256-/uLnJB/oAwLQnsZtJnUlaAEpyZVLG6o2riRwwMCH8rI=";
    })
  ];

  cmakeFlags = lib.optionals mklSupport [
    (lib.cmakeBool "USE_MKL" true)
    (lib.cmakeFeature "MKLROOT" "${mkl}")
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [ zlib ]
    ++ lib.optionals mklSupport [ mkl ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreVideo
      darwin.apple_sdk.frameworks.Accelerate
    ];

  meta = {
    description = "FEBio Suite Solver";
    license = with lib.licenses; [ mit ];
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
