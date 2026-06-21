{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  gtest,
  llvmPackages,
  meson,
  ninja,
  nix-update-script,
  nixf,
  nixt,
  nixVersions,
  pkg-config,
  python3,
  testers,
}:

let
  nixComponents = nixVersions.nixComponents_2_34;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nixd";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    tag = finalAttrs.version;
    hash = "sha256-S/E16Yf3Qh098qXxl0pimSy/5gkkd1n/Os6B9REWleg=";
  };

  sourceRoot = "${finalAttrs.src.name}/nixd";

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    llvmPackages.llvm # workaround for a meson bug, where llvm-config is not found, making the build fail
    cmake
  ];

  buildInputs = [
    nixComponents.nix-main
    nixComponents.nix-expr
    nixComponents.nix-cmd
    nixComponents.nix-flake
    nixf
    nixt
    llvmPackages.llvm
    gtest
    boost
  ];

  mesonBuildType = "release";

  # See https://github.com/nix-community/nixd/issues/519
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Feature-rich Nix language server interoperating with C++ nix";
    homepage = "https://github.com/nix-community/nixd";
    changelog = "https://github.com/nix-community/nixd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      inclyc
      Ruixi-rebirth
      aleksana
      redyf
    ];
    mainProgram = "nixd";
    platforms = lib.platforms.unix;
  };
})
