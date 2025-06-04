{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Z8ZjpD6uyqlCFItSHqAqVkdthhnwweSZasEVzg4dbpY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k3wzGEs3rRI9DG5LW7GrAGCmT0GjkUGoL73rUa9nj50=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Crafter
      techknowlogick
    ];
  };
}
