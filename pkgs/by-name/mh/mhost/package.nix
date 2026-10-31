{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mhost";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YOyJsjKpRTJrDIWiOJCuQnY9oTVsW9EFZxUkYBD7Fnc=";
  };

  cargoHash = "sha256-IRWsWsjSUC8Coa5BarF/FlHlIVPqoniOdPlr9F9hKOI=";

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
