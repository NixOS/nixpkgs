{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  llvmPackages,
}:

rustPlatform.buildRustPackage.override { inherit (llvmPackages) stdenv; } (finalAttrs: {
  pname = "openvaf";
  version = "24.0.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenVAF";
    repo = "OpenVAF-Reloaded";
    rev = "v${finalAttrs.version}mob";
    hash = "sha256-wZMZpg4X7yRVssGv8U6dupawTtzs7CLbYhaMBlxxBKo=";
  };

  cargoHash = "sha256-+jvaiBCmjd3RrlES+Sc1SskEMOtO1ykOdInMTH/Gazo=";

  nativeBuildInputs = [
    llvmPackages.llvm
  ];

  buildFeatures = [
    "llvm${lib.versions.major llvmPackages.llvm.version}"
  ];

  cargoBuildFlags = [
    "--package"
    "openvaf-driver"
  ];

  cargoTestFlags = [
    "--package"
    "openvaf-driver"
  ];

  # This is required or else nothing will build
  hardeningDisable = [
    "pic"
    "zerocallusedregs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Verilog-A compiler";
    homepage = "https://github.com/OpenVAF/OpenVAF-Reloaded";
    changelog = "https://github.com/OpenVAF/OpenVAF-Reloaded/releases/tag/v${finalAttrs.version}mob";
    mainProgram = "openvaf-r";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
