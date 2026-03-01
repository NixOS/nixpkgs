{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mhost";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-W5xXEviofY2dm1P+yFOeo6OOeOUycLsGwq9a3JpcTxU=";
  };

  cargoHash = "sha256-04Iej1jG1KazYL6hVm+itO6MmmQ/JDD0ePvKvD5wUyQ=";

  env.CARGO_CRATE_NAME = "mhost";

  doCheck = false;

  meta = {
    description = "Modern take on the classic host DNS lookup utility including an easy to use and very fast Rust lookup library";
    homepage = "https://github.com/lukaspustina/mhost";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.mgttlinger ];
    mainProgram = "mhost";
  };
})
