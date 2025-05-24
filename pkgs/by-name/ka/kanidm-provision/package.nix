{
  lib,
  rustPlatform,
  fetchFromGitHub,
  yq,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanidm-provision";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kwxGrLz59Zk8PSsfQzPUeA/xWQZrV1NWlS5/yuqfIyI=";
  };

  postPatch = ''
    tomlq -ti '.package.version = "${finalAttrs.version}"' Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-uo/TGyfNChq/t6Dah0HhXhAwktyQk0V/wewezZuftNk=";

  nativeBuildInputs = [
    yq # for `tomlq`
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) kanidm-provisioning; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oddlama ];
    mainProgram = "kanidm-provision";
  };
})
