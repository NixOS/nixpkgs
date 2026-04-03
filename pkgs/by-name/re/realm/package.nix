{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "realm";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7hOy+bqWoVyI2xGJ0eY7GvyIYykr6VP8d3ZYtY/jGPI=";
  };

  cargoHash = "sha256-yR+ayseoUYpK9lUFRP0OLrp1+LUrtPnxiPRvjDFSNgo=";

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
