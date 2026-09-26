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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    tag = "ver.${finalAttrs.version}";
    hash = "sha256-R4vxBLU7cjjk8hfN0TNFTrcJs//E70uBEHeL4fXtcJ0=";
  };

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
