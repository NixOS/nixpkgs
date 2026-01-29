{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  python3,
  opencc,
  rapidjson,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencc";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${finalAttrs.version}";
    sha256 = "sha256-JBTegQs9ALp4LdKKYMNp9GYEgqR9O8IkX6LqatvaTic=";
  };

  patches = [
    # fix build with gcc15 by adding cstdint include
    (fetchpatch {
      url = "https://github.com/BYVoid/OpenCC/commit/3d3adca2dbee0da7d33eb3c3563299fcbd2255e3.patch";
      hash = "sha256-4ZQxVnEHnNBKtEu0IPnSC/ZX7gm2cJ1Ss00PvCZr5P8=";
    })
    (fetchpatch {
      url = "https://github.com/BYVoid/OpenCC/commit/72cae18cfe4272f2b11c9ec1c44d6af7907abcab.patch";
      hash = "sha256-Cd95AsW/tLk2l8skxqfEfQUm0t23G4ocoirauwMbuwk=";
    })
    (fetchpatch {
      name = "CVE-2025-15536.patch";
      url = "https://github.com/BYVoid/OpenCC/commit/345c9a50ab07018f1b4439776bad78a0d40778ec.patch";
      hash = "sha256-lwzVRcCkMjHniaOQeoicO9fpEhyku2yhiPREk0WoXVM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    opencc # opencc_dict
  ];

  buildInputs = [
    rapidjson
  ];

  # TODO use more system dependencies
  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_RAPIDJSON" true)
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "ver."; };
  };

  meta = {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = lib.licenses.asl20;
    description = "Project for conversion between Traditional and Simplified Chinese";
    longDescription = ''
      Open Chinese Convert (OpenCC) is an opensource project for conversion between
      Traditional Chinese and Simplified Chinese, supporting character-level conversion,
      phrase-level conversion, variant conversion and regional idioms among Mainland China,
      Taiwan and Hong kong.
    '';
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
