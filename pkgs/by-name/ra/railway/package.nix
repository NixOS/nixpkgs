{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-3QdwwZMlhhO25GuhWFNI6HpvOXjXpVypP4oVqTt5zzo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ox9iqwBhdc1bPbIPlDIRK2lptoQ5kisGYr+0Ymsc3ps=";

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
