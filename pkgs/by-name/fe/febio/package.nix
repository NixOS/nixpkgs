{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  replaceVars,
  apple-sdk_11,
  cmake,
  darwinMinVersionHook,
  ninja,
  zlib,
  mklSupport ? true,
  mkl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "FEBio";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x2QYnMMiGd2x2jvBMLBK7zdJv3yzYHkJ6a+0xes6OOk=";
  };

  patches = [
    # Fix library searching and installation
    (replaceVars ./fix-cmake.patch {
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "10.15")
    ];

  meta = {
    description = "FEBio Suite Solver";
    license = with lib.licenses; [ mit ];
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
