{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  git,

  boost183,
  abseil-cpp,
  gtest,
  protobuf,
  ida-sdk_8,

  enableBinaryNinja ? true,
  enableIDA ? false,
}:
let
  # Use what's specified in cmake/BinExportDeps.cmake
  binaryninjaapi = fetchFromGitHub {
    owner = "Vector35";
    repo = "binaryninja-api";
    rev = "59e569906828e91e4884670c2bba448702f5a31d";
    hash = "sha256-XSVxQiLbTyrHyTubZWa0sIgL15/SXk2bl6ObLcGUj5w=";
    fetchSubmodules = true;
  };

  inherit (stdenv.hostPlatform.extensions) sharedLibrary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "binexport";
  version = "12-unstable-2024-11-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "binexport";
    rev = "23619ba62d88b3b93615d28fe3033489d12b38ac";
    hash = "sha256-hXb/g5BuEawUjJZPRwjKFkqZTDXDGzHSRJLYqdenMlU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    git
  ];

  buildInputs = [
    boost183
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BINEXPORT_ENABLE_IDAPRO" enableIDA)
      (lib.cmakeBool "BINEXPORT_ENABLE_BINARYNINJA" enableBinaryNinja)

      # Dependencies
      (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSL" "${abseil-cpp.src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PROTOBUF" "${protobuf.src}")
    ]
    ++ lib.optional enableBinaryNinja (
      lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BINARYNINJAAPI" "${binaryninjaapi}"
    )
    ++ lib.optional enableIDA (lib.cmakeFeature "IdaSdk_ROOT_DIR" "${ida-sdk_8}");

  postInstall =
    ''
      mkdir -p $out/bin
      mv $out/binexport-prefix/{bxp,binexport2dump} $out/bin

      mkdir -p $out/lib
    ''
    + lib.optionalString enableBinaryNinja ''
      mv $out/binexport-prefix/binexport*_binaryninja${sharedLibrary} $out/lib
    ''
    + lib.optionalString enableIDA ''
      mv $out/binexport-prefix/binexport*_ida*${sharedLibrary} $out/lib
    ''
    + ''
      rmdir $out/binexport-prefix
    '';

  meta = {
    description = "Export disassemblies into Protocol Buffers";
    longDescription = ''
      BinExport doesn't compile the IDA plugin by default as it requires a copy
      of the proprietary IDA SDK.

      If you use IDA, you can override this package with `enableIDA` set to true:
      ```nix
        binexport.override { enableIDA = true; }
      ```
      Note that this would render the entire package unfree and non-redistributable
      due to the closed-source, proprietary nature of IDA and its SDK.
    '';
    homepage = "https://github.com/google/binexport";
    license = with lib.licenses; [ asl20 ];
    platforms = with lib.platforms; lib.intersectLists x86 (unix ++ windows);
    maintainers = with lib.maintainers; [
      pluiedev
      BonusPlay
    ];
  };
})
