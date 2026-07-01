{
  cmake,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "realm";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gnsFqWhJOMKUaSWfRmHBksw3uWFP0smRhEbPLriEmlk=";
  };

  cargoHash = "sha256-b/cG6fGoAdhvmZXSQv/QkY3QKiMT7YcfEGohZSbk0q8=";

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  env.RUSTC_BOOTSTRAP = 1;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) realm; };
  };

  meta = {
    description = "Simple, high performance relay server written in rust";
    homepage = "https://github.com/zhboner/realm";
    mainProgram = "realm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ocfox ];
  };
})
