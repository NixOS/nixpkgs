{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "relay-server";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "No-Instructions";
    repo = "relay-server";
    rev = finalAttrs.version;
    hash = "sha256-9UhyRJ10JthiZM1ipXNp5UrzXXmUwfMkEYE3ecddgM8=";
  };

  sourceRoot = "${finalAttrs.src.name}/crates";

  cargoHash = "sha256-r69vyDokrexfaZ655J6kTWJfZRl1BiV/1LmkzVgLirY=";

  cargoBuildFlags = [
    "--package"
    "relay"
  ];

  cargoTestFlags = [
    "--package"
    "relay"
  ];

  # Sets the value of the "relay-server-version" HTTP response header
  env.GIT_VERSION = finalAttrs.version;

  meta = {
    description = "Self-hosted document collaboration server for Relay.md";
    homepage = "https://github.com/No-Instructions/relay-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sweenu ];
    mainProgram = "relay";
    platforms = lib.platforms.linux;
  };
})
