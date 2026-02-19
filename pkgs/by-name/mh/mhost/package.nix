{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mhost";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Z+h2vHVKIv0SHUe910RWHJF0iXWjtsxbRog/Ff8ofec=";
  };

  cargoHash = "sha256-08pvkBa2PD7/uko1OOBg6/dCcOM3z9Cp//8mylFCMcE=";

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
