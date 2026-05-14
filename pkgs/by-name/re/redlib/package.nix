{
  lib,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,

  cmake,
  gitMinimal,

  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "redlib";
  version = "0.36.0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "a4d36e954cf1bd64f209cd8868c5a29edc81b374";
    hash = "sha256-siyD6A12UALQIV7BMd7zu1TaojleTEYtpxPszuhx1/Y=";
  };

  cargoPatches = [ ./native-roots.patch ];

  cargoHash = "sha256-qDcDrZFWcFb0LRwumOc/+boIxmc6HYz+YqmP+kqK05E=";

  nativeBuildInputs = [
    cmake
    gitMinimal
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    install --mode=444 -D contrib/redlib.service $out/lib/systemd/system/redlib.service
    substituteInPlace $out/lib/systemd/system/redlib.service \
      --replace-fail "/usr/bin/redlib" "$out/bin/redlib"
  '';

  checkFlags = [
    # All these test try to connect to Reddit.
    # utils.rs
    "--skip=test_fetching_subreddit_quarantined"
    "--skip=test_fetching_nsfw_subreddit"
    "--skip=test_fetching_ws"

    # client.rs
    "--skip=test_obfuscated_share_link"
    "--skip=test_share_link_strip_json"
    "--skip=test_localization_popular"
    "--skip=test_private_sub"
    "--skip=test_banned_sub"
    "--skip=test_gated_sub"
    "--skip=test_default_subscriptions"
    "--skip=test_rate_limit_check"

    # subreddit.rs
    "--skip=test_fetching_subreddit"
    "--skip=test_gated_and_quarantined"

    # user.rs
    "--skip=test_fetching_user"

    # These try to connect to the oauth client
    # oauth.rs
    "--skip=test_oauth_client"
    "--skip=test_oauth_client_refresh"
    "--skip=test_oauth_token_exists"
    "--skip=test_oauth_headers_len"
    "--skip=oauth::tests::test_generic_web_backend"
    "--skip=oauth::tests::test_mobile_spoof_backend"
  ];

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  passthru = {
    tests = nixosTests.redlib;
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Private front-end for Reddit (Continued fork of Libreddit)";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    mainProgram = "redlib";
    maintainers = with lib.maintainers; [
      bpeetz
      Guanran928
      ryand56
    ];
  };
}
