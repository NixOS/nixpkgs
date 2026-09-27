{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bitbake";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "meta-rust";
    repo = "cargo-bitbake";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+ovC4nZwHzf9hjfv2LcnTztM2m++tpC3mUSS/I0l6Ck=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-drupV59sBuR6AZ7jVO2EJn62I6XX5vv3QR+Mu8cLklk=";

  meta = {
    description = "Cargo extension that can generate BitBake recipes utilizing the classes from meta-rust";
    mainProgram = "cargo-bitbake";
    homepage = "https://github.com/meta-rust/cargo-bitbake";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ rvarago ];
    platforms = [ "x86_64-linux" ];
  };
})
