{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "binsider";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Un3pKb0+5rwK0tKRp+HVl3vynPt5V8YxhPiLgshL3L0=";
  };

  cargoHash = "sha256-Lcnc2fVyzip+g/mZvbMarQHkjBTNhKB5kZVTHFsR+Xo=";

  buildNoDefaultFeatures = !stdenv.hostPlatform.isLinux;

  checkType = "debug";
  checkFlags = [
    "--skip=test_extract_strings"
    "--skip=test_init"
  ];

  meta = {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ samueltardieu ];
    mainProgram = "binsider";
  };
})
