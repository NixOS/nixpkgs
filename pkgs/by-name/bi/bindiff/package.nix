{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  cmake,
  ninja,
  git,

  binexport,
  boost183,

  nix-update-script,

  enableIDA ? false,
}:
let
  binexport' = binexport.override { inherit enableIDA; };

  # needs a fixed version:
  # https://github.com/google/bindiff/blob/c8972f08a3438049f2f5e81439a70ee56f95c549/cmake/BinDiffDeps.cmake#L16-L19
  sqlite = fetchzip {
    url = "https://sqlite.org/2024/sqlite-amalgamation-3450100.zip";
    hash = "sha256-bJoMjirsBjm2Qk9KPiy3yV3+8b/POlYe76/FQbciHro=";
  };

  inherit (stdenv.hostPlatform.extensions) sharedLibrary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bindiff";
  version = "8-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bindiff";
    rev = "c8972f08a3438049f2f5e81439a70ee56f95c549";
    hash = "sha256-5EVlrQqtzPPrjmoCJ/SlvSo2bRklvwveslPfeq8CN6A=";
  };

  patches = [ ./allow-compilation-without-ida.patch ];

  nativeBuildInputs = [
    cmake
    ninja
    git
  ];

  buildInputs = [
    boost183
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BINDIFF_BINEXPORT_DIR" "${binexport'.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SQLITE" "${sqlite}")
  ] ++ binexport'.cmakeFlags;

  postInstall =
    ''
      mkdir -p $out/bin
    ''
    + lib.optionalString enableIDA ''
      mkdir -p $out/lib
      mv $out/bindiff-prefix/bindiff*_ida*${sharedLibrary} $out/lib
    ''
    + ''
      mv $out/bindiff-prefix/bindiff* $out/bin
    ''
    + ''
      rmdir $out/bindiff-prefix
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quickly find differences and similarities in disassembled code";
    longDescription = ''
      BinDiff doesn't compile the IDA plugin by default as it requires a copy
      of the proprietary IDA SDK.

      If you use IDA, you can override this package with `enableIDA` set to true:
      ```nix
        bindiff.override { enableIDA = true; }
      ```
      Note that this would render the entire package unfree and non-redistributable
      due to the closed-source, proprietary nature of IDA and its SDK.
    '';
    homepage = "https://zynamics.com/bindiff.html";
    license = with lib.licenses; [ asl20 ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [
      pluiedev
      BonusPlay
    ];
  };
})
