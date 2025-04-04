{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "samply";
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zTwAsE6zXY3esO7x6UTCO2DbzdUSKZ6qc5Rr9qcI+Z8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mQykzO9Ldokd3PZ1fY4pK/GtLmYMVas2iHj1Pqi9WqQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line profiler for macOS and Linux";
    homepage = "https://github.com/mstange/samply";
    changelog = "https://github.com/mstange/samply/releases/tag/samply-v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "samply";
  };
}
