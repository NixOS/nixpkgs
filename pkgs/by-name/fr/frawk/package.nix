{
  lib,
  rustPlatform,
  fetchCrate,
  libxml2,
  ncurses,
  zlib,
  features ? [ "default" ],
  llvmPackages_12,
}:

rustPlatform.buildRustPackage rec {
  pname = "frawk";
  version = "0.4.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wPnMJDx3aF1Slx5pjLfii366pgNU3FJBdznQLuUboYA=";
  };

  cargoHash = "sha256-Xk+iH90Nb2koCdGmVSiRl8Nq26LlFdJBuKmvcbgnkgs=";

  buildInputs = [
    libxml2
    ncurses
    zlib
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = features;

  preBuild =
    lib.optionalString (lib.elem "default" features || lib.elem "llvm_backend" features) ''
      export LLVM_SYS_120_PREFIX=${llvmPackages_12.llvm.dev}
    ''
    + lib.optionalString (lib.elem "default" features || lib.elem "unstable" features) ''
      export RUSTC_BOOTSTRAP=1
    '';

  # depends on cpu instructions that may not be available on builders
  doCheck = false;

  meta = with lib; {
    description = "Small programming language for writing short programs processing textual data";
    mainProgram = "frawk";
    homepage = "https://github.com/ezrosent/frawk";
    changelog = "https://github.com/ezrosent/frawk/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
