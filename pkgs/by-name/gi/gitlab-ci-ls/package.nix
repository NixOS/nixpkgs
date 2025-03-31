{
  rustPlatform,
  lib,
  fetchFromGitHub,
  darwin,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-ci-ls";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
    hash = "sha256-SVsQnY/TrFQXgvT5goXQqb5MYxU7untDq361EY7KRDQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7qZN198hqAmAd3WH8g+ceSGvQuZ0EheHeMwmvBd9if4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
    mainProgram = "gitlab-ci-ls";
  };
}
