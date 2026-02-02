{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rover";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = "rover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/uVaj1+J8wQhc/mTCr9RaMMzEIXdJoRU5iX7/eYZMA=";
  };

  cargoHash = "sha256-Z9B9DKu6t78Xd75EAKXfB+nr1Au4ylYkZojiENxSykQ=";

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  __darwinAllowLocalNetworking = true;

  # This test checks whether the plugins specified in the plugins json file are
  # valid by making a network call to the repo that houses their binaries; but, the
  # build env can't make network calls (impurity)
  cargoTestFlags = [
    "--"
    "--skip=latest_plugins_are_valid_versions"
  ];

  # Some tests try to write configuration data to a location in the user's home
  # directory. Since this would be /homeless-shelter during the build, point at
  # a writeable location instead.
  preCheck = ''
    export APOLLO_CONFIG_HOME="$PWD"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for interacting with ApolloGraphQL's developer tooling, including managing self-hosted and GraphOS graphs";
    mainProgram = "rover";
    homepage = "https://www.apollographql.com/docs/rover";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.ivanbrennan
      lib.maintainers.aaronarinder
    ];
  };
})
