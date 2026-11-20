{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  llvmPackages,
}:

rustPlatform.buildRustPackage.override { inherit (llvmPackages) stdenv; } (finalAttrs: {
  pname = "openvaf";
  version = "24.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OpenVAF";
    repo = "OpenVAF-Reloaded";
    rev = "v${finalAttrs.version}mob";
    hash = "sha256-XTfi2hxPLT3tWdudrKOJ5VnvyUTfACirMgItmxJ9yjo=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)mob$"
    ];
  };

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
