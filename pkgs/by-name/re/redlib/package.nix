{ lib
, stdenv
, cacert
, nixosTests
, rustPlatform
, fetchFromGitHub
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "redlib";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-d3Jjs/a2EgdqRBTjXKwDDRnU6orb7RQGl1CVz9b9SdI=";
  };

  cargoHash = "sha256-2MugS0/MO85lQvDbiFwnsX4LYdk7TACDFR8OOLEFGUQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # All these test try to connect to Reddit.
    "--skip=test_fetching_subreddit_quarantined"
    "--skip=test_fetching_nsfw_subreddit"
    "--skip=test_fetching_ws"

    "--skip=test_obfuscated_share_link"
    "--skip=test_share_link_strip_json"

    "--skip=test_localization_popular"
    "--skip=test_fetching_subreddit"
    "--skip=test_fetching_user"

    # These try to connect to the oauth client
    "--skip=test_oauth_client"
    "--skip=test_oauth_client_refresh"
    "--skip=test_oauth_token_exists"
  ];

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  passthru.tests = {
    inherit (nixosTests) redlib;
  };

  meta = {
    changelog = "https://github.com/redlib-org/redlib/releases/tag/v${version}";
    description = "Private front-end for Reddit (Continued fork of Libreddit)";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    mainProgram = "redlib";
    maintainers = with lib.maintainers; [ soispha ];
  };
}
