{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.36.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-rqJ6+QKfEhdHGZBT9yEWtsBlETxz4XeEZXisXf7RdIE=";
  };

  cargoHash = "sha256-wFRZhQzFBwwNfiszwr7XK3e8tfqqFG6DIe7viWvB5vg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jraygauthier ];
    mainProgram = "geckodriver";
  };
})
