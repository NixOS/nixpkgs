{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  gtest,
  llvmPackages,
  meson,
  mesonEmulatorHook,
  ninja,
  nixVersions,
  nlohmann_json,
  pkg-config,
  python3,
  testers,
}:

let
  nixComponents = nixVersions.nixComponents_2_34;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nixf";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    tag = finalAttrs.version;
    hash = "sha256-S/E16Yf3Qh098qXxl0pimSy/5gkkd1n/Os6B9REWleg=";
  };

  sourceRoot = "${finalAttrs.src.name}/libnixf";

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    llvmPackages.llvm # workaround for a meson bug, where llvm-config is not found, making the build fail
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [
    nixComponents.nix-expr
    gtest
    boost
    nlohmann_json
  ];

  mesonBuildType = "release";

  doCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nixf" ];
  };

  meta = {
    description = "Nix language frontend, parser & semantic analysis";
    homepage = "https://github.com/nix-community/nixd";
    changelog = "https://github.com/nix-community/nixd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      inclyc
      Ruixi-rebirth
      aleksana
      redyf
    ];
    mainProgram = "nixf-tidy";
    platforms = lib.platforms.unix;
  };
})
