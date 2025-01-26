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
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
    hash = "sha256-G0MKq2qGxcMpNOQDHo9LtewDEExYIA8/kTUkiZdnygg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0Ll1C4N3Zx/SDnlXdIzUa88q/SCSsptFYnHM+uVwPZM=";

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
