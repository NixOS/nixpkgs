{
  lib,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "redlib";
<<<<<<< HEAD
  version = "0.36.0-unstable-2025-12-16";
=======
  version = "0.36.0-unstable-2025-09-09";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
<<<<<<< HEAD
    rev = "ba98178bbce0f62265095ba085128c7022e51a1f";
    hash = "sha256-ERTEoT7w8oGA0ztrzc9r9Bl/7OOay+APg3pW+h3tgvM=";
  };

  cargoHash = "sha256-ageSjIX0BLVYlLAjeojQq5N6/VASOIpwXNR/3msl/p4=";
=======
    rev = "a989d19ca92713878e9a20dead4252f266dc4936";
    hash = "sha256-YJZVkCi8JQ1U47s52iOSyyf32S3b35pEqw4YTW8FHVY=";
  };

  cargoHash = "sha256-L35VSQdIbKGGsBPU2Sj/MoYohy1ZibgZ+7NVa3yNjH8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    "--skip=oauth::test_generic_web_backend"
    "--skip=oauth::test_mobile_spoof_backend"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    ];
  };
}
