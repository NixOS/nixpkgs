{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  openssl,
<<<<<<< HEAD
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rover";
  version = "0.37.0";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "rover";
  version = "0.24.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = "rover";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/uVaj1+J8wQhc/mTCr9RaMMzEIXdJoRU5iX7/eYZMA=";
  };

  cargoHash = "sha256-Z9B9DKu6t78Xd75EAKXfB+nr1Au4ylYkZojiENxSykQ=";
=======
    rev = "v${version}";
    sha256 = "sha256-uyeePAHBDCzXzwIWrKcc9LHClwSI7DMBYod/o4LfK+Y=";
  };

  cargoHash = "sha256-uR5XvkHUmZzCHZITKgScmzqjLOIvbPyrih/0B1OpsAc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # This test checks whether the plugins specified in the plugins json file are
  # valid by making a network call to the repo that houses their binaries; but, the
  # build env can't make network calls (impurity)
  cargoTestFlags = [
    "-- --skip=latest_plugins_are_valid_versions"
  ];

<<<<<<< HEAD
=======
  passthru.updateScript = ./update.sh;

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Some tests try to write configuration data to a location in the user's home
  # directory. Since this would be /homeless-shelter during the build, point at
  # a writeable location instead.
  preCheck = ''
    export APOLLO_CONFIG_HOME="$PWD"
  '';

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "CLI for interacting with ApolloGraphQL's developer tooling, including managing self-hosted and GraphOS graphs";
    mainProgram = "rover";
    homepage = "https://www.apollographql.com/docs/rover";
    license = licenses.mit;
    maintainers = [
      maintainers.ivanbrennan
      maintainers.aaronarinder
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
