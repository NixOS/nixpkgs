{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "eureka-ideas";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "simeg";
    repo = "eureka";
    rev = "v${version}";
    sha256 = "sha256-NJ1O8+NBG0y39bMOZeah2jSZlvnPrtpCtXrgAYmVrAc=";
  };

  cargoHash = "sha256-nTYMKJ5OCApqooIF1dsDLriPfYjkZkTdtzpkJya/5ag=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
  ];

  useNextest = true;

  meta = {
    description = "CLI tool to input and store your ideas without leaving the terminal";
    homepage = "https://github.com/simeg/eureka";
    changelog = "https://github.com/simeg/eureka/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "eureka";
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
